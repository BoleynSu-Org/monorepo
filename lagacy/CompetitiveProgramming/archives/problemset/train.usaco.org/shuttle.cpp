/*
ID: sujiao1
PROG: shuttle
LANG: C++
*/
/*
PROGRAM: shuttle
AUTHOR: Su Jiao
DATE: 2010-1-10
DESCRIPTION:
��СΪ3��������Ϸ����3����ɫ���ӣ�3����ɫ���ӣ���һ����7������һ���ſ���ľ���ӡ�3�������ӱ�����һͷ��3�������ӱ�������һͷ���м�ĸ��ӿ��š� 
��ʼ״̬: WWW_BBB 
Ŀ��״̬: BBB_WWW
�������Ϸ���������ƶ�����������ģ� 
����԰�һ�������Ƶ��������ڵĿո� 
����԰�һ����������һ��(��һ��)������ͬɫ�����ӵ���ո� 
��СΪN��������Ϸ����N�������ӣ�N�������ӣ�������2N+1�����ӵ�ľ���ӡ� 
������3-������Ϸ�Ľ⣬������ʼ״̬���м�״̬��Ŀ��״̬�� 
 WWW BBB
 WW WBBB
 WWBW BB
 WWBWB B
 WWB BWB
 W BWBWB
  WBWBWB
 BW WBWB
 BWBW WB
 BWBWBW 
 BWBWB W
 BWB BWW
 B BWBWW
 BB WBWW
 BBBW WW
 BBB WWW
���һ��������СΪN��������Ϸ(1 <= N <= 12)��Ҫ�������ٵ��ƶ�����ʵ�֡� 
*/
#include <fstream>
using std::ifstream;
using std::ofstream;
using std::endl;
#include <cstring>
using std::memset;

class Application
{
      ifstream cin;
      ofstream cout;
      static const int MAXN=12;
      //                        1 2 3 4 5 6 7 8 9 0 1 2
      static const int MAXSTATE=3*3*3*3*3*3*3*3*3*3*3*3;
      int N;
      typedef int string[MAXN*2+2];
      public:
      Application(char* input,char* output)
      :cin(input),cout(output)
      {
                              cin>>N;
      }
      ~Application()
      {
                    cin.close();
                    cout.close();
      }
      static int link[MAXSTATE+2];
      static int opt[MAXSTATE+2];
      static long long int q[MAXSTATE+2];
      //static int step[MAXSTATE+2];
      int open,close;
      void bfs(long long int s,long long int t)
      {
           //memset(step,0,sizeof(step));
           //cout<<s<<" "<<t<<endl;
           open=1;
           close=1;
           
           q[open]=s;
           //step[q[open]]=1;
           link[open]=close;
           opt[q[open]]=N+1;
           long long int next;
           while (close<=open)
           {
                 long long int now=q[close];
                 string ns;
                 toString(now,ns);
                 //printString(ns);
                 for (int i=1;i<=N*2+1;i++)
                 {
                     if (ns[i]==2)
                     {
                        if ((i>1)&&(ns[i-1]==0))
                        {
                           ns[i]=ns[i-1];
                           ns[i-1]=2;
                           next=toInteger(ns);
                           //printString(ns);                      
                           //if (!step[next])
                           {
                              //step[next]=step[now]+1;
                              q[++open]=next;
                              //step[open]=step[close]+1;
                              link[open]=close;
                              opt[open]=i-1;
                              if (q[open]==t) return;
                           }
                           ns[i-1]=ns[i];
                           ns[i]=2;
                        }
                        if ((i<N*2+1)&&(ns[i+1]==1))
                        {
                           ns[i]=ns[i+1];
                           ns[i+1]=2;
                           next=toInteger(ns);
                           //printString(ns);                      
                           //if (!step[next])
                           {
                              //step[next]=step[now]+1;
                              q[++open]=next;
                              //step[open]=step[close]+1;
                              link[open]=close;
                              opt[open]=i+1;
                              if (q[open]==t) return;
                           }
                           ns[i+1]=ns[i];
                           ns[i]=2;
                        }
                        if ((i>1+1)&&(ns[i-1]==1)&&(ns[i-2]==0))
                        {
                           ns[i]=ns[i-2];
                           ns[i-2]=2;
                           next=toInteger(ns);
                           //printString(ns);                      
                           //if (!step[next])
                           {
                              //step[next]=step[now]+1;
                              q[++open]=next;
                              //step[open]=step[close]+1;
                              link[open]=close;
                              opt[open]=i-2;
                              if (q[open]==t) return;
                           }
                           ns[i-2]=ns[i];
                           ns[i]=2;                                  
                        }
                        if ((i<N*2+1-1)&&(ns[i+1]==0)&&(ns[i+2]==1))
                        {
                           ns[i]=ns[i+2];
                           ns[i+2]=2;
                           next=toInteger(ns);
                           //printString(ns);                      
                           //if (!step[next])
                           {
                              //step[next]=step[now]+1;
                              q[++open]=next;
                              //step[open]=step[close]+1;
                              link[open]=close;
                              opt[open]=i+2;
                              if (q[open]==t) return;
                           }
                           ns[i+2]=ns[i];
                           ns[i]=2;
                        }
                     }
                 }
                 //cout<<open<<endl;
                 close++;
           }
      }
      void print()
      {
           int now=open;           
           static const int MAXOUTPUT=1000;
           int output[MAXOUTPUT];
           int output_top=0;
           while (link[now]!=now)
           {
                 output[++output_top]=opt[now];
                 now=link[now];
           }
           for (int i=output_top;i>=1;i--)
           {
               cout<<output[i]<<char(((i==1)||((output_top-i+1)%20)==0)?'\n':' ');
           }
      }
      void toString(long long int i,string s)
      {
           for (int j=1;j<=N*2+1;j++)
           {
               s[N*2+1+1-j]=i%3;
               i/=3;
           }
      }
      void printString(string s)
      {
           for (int i=1;i<=N*2+1;i++)
               cout<<s[i];
           cout<<endl;
      }
      long long 
      int toInteger(string s)
      {
          long long int i=0;
          for (int j=1;j<=N*2+1;j++)
              i=i*3+s[j];
          return i;
      }
      long long 
      int getStart()
      {
          //[0]n 2 [1]n
          long long int v=0;
          for (int i=1;i<=N;i++)
              v=v*3+0;
          v=v*3+2;
          for (int i=1;i<=N;i++)
              v=v*3+1;
          return v;
      }
      long long 
      int getEnd()
      {
          //[1]n 2 [0]n
          long long int v=0;
          for (int i=1;i<=N;i++)
              v=v*3+1;
          v=v*3+2;
          for (int i=1;i<=N;i++)
              v=v*3+0;
          return v;
      }
      int run()
      {
          //bfs
          bfs(getStart(),getEnd());
          print();
          return 0;
      }
};
int Application::link[MAXSTATE+2];
int Application::opt[MAXSTATE+2];
long long int Application::q[MAXSTATE+2];
//int Application::step[MAXSTATE+2];

int main()
{
    Application app("shuttle.in","shuttle.out");
    return app.run();
}
