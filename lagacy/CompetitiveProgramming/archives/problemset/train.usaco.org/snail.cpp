/*
ID: sujiao1
PROG: snail
LANG: C++
*/
/*
PROGRAM: snail
AUTHOR: Su Jiao
DATE: 2010-1-14
DESCRIPTION:
������˹�ڶ���Sally Snail����ţ��ϲ���� N x N ���������й䣨1 < n <= 120������
���Ǵ����̵����Ͻǳ������������пյĸ��ӣ��á�.������ʾ���� B ��·�ϣ��á�#����
��ʾ�������������ֱ�ʾ����ʾ�����̣� 
         A B C D E F G H
       1 S . . . . . # .
       2 . . . . # . . .
       3 . . . . . . . .
       4 . . . . . . . .
       5 . . . . . # . .
       6 # . . . . . . .
       7 . . . . . . . .
       8 . . . . . . . .
�������Ǵ�ֱ�����ϻ������£���ˮƽ������������ң����ߡ������Դӳ����أ����Ǽ���
 A1 �����»��������ߡ�һ������ѡ����һ���������ͻ�һֱ����ȥ��������������̱�
 Ե����·�ϣ�����ͣ����������ת�� 90 �ȡ����������뿪���̣������߽�·�ϵ��С���
 �ң������Ӳ�������Ѿ������ĸ��ӡ�������Ҳ�����ߵ�ʱ������ֹͣɢ���� 
����������������ϵ�һ��ɢ��·��ͼʾ�� 
         A B C D E F G H
       1 S---------+ # .
       2 . . . . # | . .
       3 . . . . . | . .
       4 . . . . . +---+
       5 . . . . . # . |
       6 # . . . . . . |
       7 +-----------+ |
       8 +-------------+
���������ߣ������£����ң����£�Ȼ�����������ϣ���������ߡ���ʱ��������һ����
�Ѿ��߹��ĸ��ӣ�����ͣ�����ˡ����ǣ�������� F5 ������·�Ϻ�ѡ������һ��·������
���ǿ�������ߵķ���ת�䣬����Ͳ�һ���ˡ� 
��������Ǽ��㲢������������������ѡ������·�ߵĻ��������ܹ�����������������
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
      static const int MAXN=120;
      int N;
      int M;
      bool map[MAXN+2][MAXN+2];
      bool got[MAXN+2][MAXN+2];
      int answer;
      public:
      Application(char* input,char* output)
                        :cin(input),cout(output)
      {
                        cin>>N>>M;
                        memset(map,false,sizeof(map));
                        memset(got,false,sizeof(got));
                        for (int i=1;i<=M;i++)
                        {
                            char x;
                            int y;
                            cin>>x>>y;
                            map[x-'A'+1][y]=true;
                        }
      }
      ~Application()
      {
                    cin.close();
                    cout.close();
      }
      void dfs()
      {
           
      }
      bool canGet(int x,int y)
      {
           return !(x<1||y<1||x>N||y>N||map[x][y]);
      }
      void dfs(int x,int y,int dx,int dy,int get)
      {
           if (get>answer) answer=get;
           if (!canGet(x,y)||got[x][y])
              return;
           //cout<<x<<","<<y<<":"<<get<<endl;
           got[x][y]=true;
           if (!canGet(x+dx,y+dy))
           {
              dfs(x-dy,y-dx,-dy,-dx,get+1);
              dfs(x+dy,y+dx,dy,dx,get+1);
           }
           else
               dfs(x+dx,y+dy,dx,dy,get+1);
           got[x][y]=false;
      }
      int run()
      {
          answer=0;
          dfs(1,1,0,1,0);
          dfs(1,1,1,0,0);
          cout<<answer<<endl;
          return 0;
      }
};

int main()
{
    Application app("snail.in","snail.out");
    return app.run();
}
