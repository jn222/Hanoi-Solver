#include <stdio.h>

void hanoi(int disk, int *source, int *dest, int *spare, char csource, char cdest, char cspace);

void move(int disk, int *source, int *dest, char *csource, char *cdest);

main(){
  int disk_num;
  do{
    printf("Welcome to the Tower of Hanoi Puzzle Solver.\nEnter the number of disks in the scenario.\n");
    scanf("%u", &disk_num);
    int source[disk_num], spare[disk_num], dest[disk_num];
    int i;
    for (i=1; i<=disk_num; i++)
      source[i]=i;
    hanoi(disk_num, &source[0], &dest[disk_num-1], &spare[disk_num-1], 'A', 'C', 'B');
    printf("Done. Is there another Tower of Hanoi Puzzle you wish to compute?\nEnter (1) for yes and (0) to quit.\n");
    scanf("%u", &disk_num);
  }while(disk_num);
  return;
}

void hanoi(int disk, int *source, int *dest, int *spare, char csource, char cdest, char cspare){
  if(disk==1)
    move(disk, source, dest, &csource, &cdest);
  else{
    hanoi(disk-1, source, spare, dest, csource, cspare, cdest);
    move(disk, source, dest, &csource, &cdest);
    hanoi(disk-1, spare, dest, source, cspare, cdest, csource);
  }
  return; 
}

void move(int disk, int *source, int *dest, char *csource, char *cdest){
  *dest=*source;
  dest--;
  source = NULL;
  source++;
  printf("Move disk %u from peg %c to peg %c.\n", disk, *csource, *cdest);
  return;
}
