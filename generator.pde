/*
 * connection
 *
 * .-.-.-.  <- connection[0][j] (j=0, ..., N-2)
 * | | | |  <- connection[1][j] (j=0, ..., N-1)
 * .-.-.-.
 * | | | |
 * .-.-.-.
 * | | | |
 * .-.-.-. <- connection[2*N-2][j]
 *
 */
 
import java.util.*;

boolean[][] connection;

int connection_count(int x, int y) {
    int already = 0;

    if (x>0 && connection[x*2-1][y]) already++;
    if (x<N-1 && connection[x*2+1][y]) already++;
    if (y>0 && connection[x*2][y-1]) already++;
    if (y<N-1 && connection[x*2][y]) already++;

    return already;
}

boolean reachable(int x1, int y1, int x2, int y2) {
    boolean[][] visited = new boolean[N][N];
    for (int i=0; i<N; i++) for (int j=0; j<N; j++) visited[i][j] = false;

    Queue<Integer> q = new LinkedList<Integer>();
//    queue< pair<int, int> > q;
    q.offer(x1 * N + y1);
    while (q.size() > 0) {
        int c = q.poll();
        int x = c/N;
        int y = c%N;

        if (x == x2 && y == y2) return true;
        if (visited[x][y]) continue;

        visited[x][y] = true;

        // up
        if (x > 0 && connection[x*2-1][y]) {
            q.offer((x-1)*N + y);
        }
        // down
        if (x < N-1 && connection[x*2+1][y]) {
            q.offer((x+1)*N + y);
        }
        // left
        if (y > 0 && connection[x*2][y-1]) {
            q.offer(x*N + (y-1));
        }
        // right
        if (y < N-1 && connection[x*2][y]) {
            q.offer(x*N + (y+1));
        }
    }

    return false;
}

void append_connection() {
    while (true) {
        // 適当に一つ新しい接続を作る
        int i, j;
        while (true) {
            i = (int)random(0, N*2-1);
            if (i%2 == 1)
                j = (int)random(0, N);
            else
                j = (int)random(0, N-1);
            if (!connection[i][j]) break;
        }

        int x1, y1, x2, y2;
        if (i%2 == 0) { // 横線
            x1 = i/2;
            y1 = j;
            x2 = i/2;
            y2 = j + 1;
        } else { // 縦線
            x1 = i/2;
            y1 = j;
            x2 = i/2 + 1;
            y2 = j;
        }

        // 十字路を作らない (すでにT字路だったらキャンセル)
        if (connection_count(x1, y1) == 3 || connection_count(x2, y2) == 3) {
            continue;
        }

        // 閉路を作らない (すでに到達可能だったらキャンセル)
        if (reachable(x1, y1, x2, y2)) {
            continue;
        }
        connection[i][j] = true;
        break;
    }
}

void visualize() {
    for (int i=0; i<2*N-1; i++) {
        if (i%2 == 0) { // 横線
            for (int j=0; j<N-1; j++) {
//                cerr << "." << (connection[i][j] ? "-" : " ");
                print("." + (connection[i][j] ? "-" : " "));
            }
//            cerr << "." << endl;
            println(".");
        } else { // 縦線
            for (int j=0; j<N; j++) {
//                cerr << (connection[i][j] ? "|" : " ") << " ";
                print((connection[i][j] ? "|" : " ") + " ");
            }
            println();
        }
    }
}

void output() {
    stage = new int[N][N];
    rotation = new int[N][N];
    supplied = new boolean[N][N];
    
    for (int i=0; i<N; i++) {
        for (int j=0; j<N; j++) {
            int count = connection_count(i, j);
            switch (count) {
                case 1:
                    stage[i][j] = 0;
                    break;
                case 2:
                    if (((j>0 && connection[i*2][j-1])
                        && (j<N-1 && connection[i*2][j])) ||
                        ((i>0 && connection[i*2-1][j])
                        && (i<N-1 && connection[i*2+1][j]))) {
                          stage[i][j] = 1;
                    } else {
                          stage[i][j] = 2;
                    }
                    break;
                case 3:
                      stage[i][j] = 3;
                    break;
            }
            rotation[i][j] = (int)random(0, 4);
        }
    }
}

void generate(int n) {
    N = n;
    
    connection = new boolean[N*2-1][N];
    
    for (int i=0; i<N*N-1; i++) {
        append_connection();
    }
    visualize();
    output();
}


