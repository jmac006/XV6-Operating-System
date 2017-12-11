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

//cs153 Mac/Wilson: need to modify kalloc to return pointer to frame
char* new_kmalloc(void) {
  char *frame;
  uint size;
  size = PGROUNDUP(myproc()->sz + PGSIZE);
  frame = kalloc();
  if(frame == 0) {
    cprintf("new_kmalloc error \n");
    return((char*)0);
  }
  memset(frame, 0, PGSIZE);
  //V2P function in memlayout.h
  if(mappages(myproc()->pgdir, (char*)size, PGSIZE, V2P(frame), PTE_W|PTE_U) < 0) {
    cprintf("new_kmalloc failed to map pages\n");
    kfree(frame);
    return((char*)0);
  }

  return ((char*) V2P(frame));
}

int shm_open(int id, char **pointer) {
  int index = 0;
  char* frame;
  uint size;

  acquire(&(shm_table.lock)); //race condition

  int i = 0;
  //traverse shm_table, check to see if shm_
  for(i = 0; i < 64; i++) {
    if(shm_table.shm_pages[i].id == id) {
      //CASE 1: Another process did shm_open
      cprintf("Case 1\n");
      size = PGROUNDUP(myproc()->sz + PGSIZE);
      frame = shm_table.shm_pages[index].frame;
      cprintf("sz: %d  frame: %x\n",size,frame);
      if(mappages(myproc()->pgdir, (char*)size, PGSIZE, V2P(frame),PTE_W|PTE_U) < 0) {
        cprintf("failed to map with existing page\n");
        release(&(shm_table.lock));
        return -1;
      }
      shm_table.shm_pages[index].refcnt++;
      *pointer = (char*)frame;
      myproc()->sz += PGSIZE;
      release(&(shm_table.lock));
      return id;
    }
    index++;
  }

  //CASE 2: Shared memory segment not found in table
  cprintf("Case 2\n");
  index = 0;
  for(i = 0; i < 64; i++) {
    if(shm_table.shm_pages[i].refcnt == 0) {
      shm_table.shm_pages[index].refcnt++;
      shm_table.shm_pages[index].id = id; 
      shm_table.shm_pages[index].frame = new_kmalloc();
      cprintf("id %d\n",id);
      *pointer = (char *)shm_table.shm_pages[index].frame;
      myproc()->sz += PGSIZE;
      release(&(shm_table.lock));
      return id;
    }
    index++;
  }

  //OTHER
  release(&(shm_table.lock));
  return 0; //added to remove compiler warning -- you should decide what to return
}


int shm_close(int id) {
//you write this too!
  int i = 0;
  for(i = 0; i < 64; i++) {
    if(shm_table.shm_pages[i].id == id) {
      shm_table.shm_pages[i].refcnt--;
      if(shm_table.shm_pages[i].refcnt == 0) {
        shm_table.shm_pages[i].id = 0;
      }
    }
  }


  return 0; //added to remove compiler warning -- you should decide what to return
}
