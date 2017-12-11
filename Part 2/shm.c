#include "param.h"
#include "types.h"
#include "defs.h"
#include "x86.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"

struct {
  struct spinlock lock;
  struct shm_page {
    uint id;
    char *frame;
    int refcnt;
  } shm_pages[64];
} shm_table;

void shminit() {
  int i;
  initlock(&(shm_table.lock), "SHM lock");
  acquire(&(shm_table.lock));
  for (i = 0; i< 64; i++) {
    shm_table.shm_pages[i].id =0;
    shm_table.shm_pages[i].frame =0;
    shm_table.shm_pages[i].refcnt =0;
  }
  release(&(shm_table.lock));
}


int shm_open(int id, char **pointer) {
  //uint size = myproc()->sz;
  acquire(&(shm_table.lock)); //race condition

  int i = 0;
  //traverse shm_table

  for(i = 0; i < 64; i++) {
    if(shm_table.shm_pages[i].id == id) {
      //CASE 1: Another process did shm_open
      //cprintf("case 1\n");
      shm_table.shm_pages[i].refcnt++;
      if(mappages(myproc()->pgdir, (void *)myproc()->sz, PGSIZE, V2P((shm_table.shm_pages[i].frame)), PTE_W|PTE_U) < 0) {
        cprintf("failed to map with existing page\n");
        release(&(shm_table.lock));
        return -1;
      }
      *pointer = (char *)myproc()->sz;
      myproc()->sz += PGSIZE;
      
      release(&(shm_table.lock));
      return id;
    }
  }
  

  //CASE 2: Shared memory segment not found in table
  //cprintf("case 2\n");
  for(i = 0; i < 64; i++) {
    if(shm_table.shm_pages[i].id == 0) {

      shm_table.shm_pages[i].frame = kalloc();

      memset(shm_table.shm_pages[i].frame, 0, PGSIZE);

      mappages(myproc()->pgdir, (void *)myproc()->sz, PGSIZE, V2P((shm_table.shm_pages[i].frame)), PTE_W|PTE_U);
      *pointer = (char *)myproc()->sz;
      myproc()->sz += PGSIZE;
      shm_table.shm_pages[i].id = id;
      shm_table.shm_pages[i].refcnt += 1;

      release(&(shm_table.lock));
      return id;
    }
  }

  //OTHER
  release(&(shm_table.lock));
  return 0; //added to remove compiler warning -- you should decide what to return
}

int shm_close(int id) {
  initlock(&(shm_table.lock), "SHM lock");
  acquire(&(shm_table.lock)); //race condition
  int i = 0;
  for(i = 0; i < 64; i++) {
    if(shm_table.shm_pages[i].id == id) {
      shm_table.shm_pages[i].refcnt--;
      if(shm_table.shm_pages[i].refcnt == 0) {
        shm_table.shm_pages[i].id = 0;
      }
      break;
    }
  }

  release(&(shm_table.lock));
  return 0; //added to remove compiler warning -- you should decide what to return
}