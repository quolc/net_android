int[] dx = {-1, 0, 1, 0};
int[] dy = {0, 1, 0, -1};

void update_supplied() {
    int supplied_count = 0;
  
    for (int i=0; i<N; i++) {
      for (int j=0; j<N; j++) {
        supplied[i][j] = false;
      }
    }
  
    Queue<Integer> q = new LinkedList<Integer>();
    q.offer((N/2)*N + N/2);
    
    while (q.size() > 0) {
      int c = q.poll();
      int x = c/N;
      int y = c%N;
      
      if (supplied[x][y]) continue;
      supplied[x][y] = true;
      supplied_count++;
      
      for (int i=0; i<4; i++) {
        if (connected[stage[x][y]][(i-rotation[x][y]+4)%4]) {
          int x2 = x+dx[i];
          int y2 = y+dy[i];
          int i2 = (i+2) % 4;
          if (!(x2 < 0 || x2 >= N || y2 < 0 || y2 >= N) &&
              connected[stage[x2][y2]][(i2-rotation[x2][y2]+4)%4]) {
            q.offer((x+dx[i])*N + (y+dy[i]));
          }
        }
      }
    } 
    if (supplied_count == N*N) {
      println("cleared");
      mode = 2;
    }
}
