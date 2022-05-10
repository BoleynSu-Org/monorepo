/*
ID: sujiao1
PROG: schlnet
LANG: C++
*/
/*
PROGRAM: schlnet
AUTHOR: Su Jiao
DATE: 2010-1-17
DESCRIPTION:
һЩѧУ����һ���������硣��ЩѧУ�Ѷ�����Э�飺ÿ��ѧУ�����������һЩѧУ�ַ�
���������������ѧУ������ע����� B �� A ѧУ�ķַ��б��У���ô A ��һ��Ҳ�� B 
ѧУ���б��С� 
��Ҫдһ��������㣬����Э�飬Ϊ�������������е�ѧУ�������������������������
����������ѧУ��Ŀ�������� A��������һ����������Ҫȷ��ͨ��������һ��ѧУ��������
�����������ͻ�ַ��������е�����ѧУ��Ϊ���������������ǿ��ܱ�����չ����ѧ
У�б�ʹ������³�Ա������������Ҫ���Ӽ�����չ��ʹ�ò������Ǹ��ĸ�ѧУ��������
���������ᵽ���������е�ѧУ�������� B����һ����չ������һ��ѧУ�Ľ���ѧУ�б���
����һ���³�Ա�� 
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
      static const int MAXN=100;
      int N;
      bool m[MAXN+2][MAXN+2];
      public:
      Application(char* input,char* output)
                        :cin(input),cout(output)
      {
                        memset(m,false,sizeof(m));
                        cin>>N;
                        for (int i=1;i<=N;i++)
                        {
                            int t;
                            for (;;)
                            {
                                cin>>t;
                                if (t) m[i][t]=true;
                                else break;
                            }
                        }
      }
      ~Application()
      {
                    cin.close();
                    cout.close();
      }
      int run()
      {
          for (int k=1;k<=N;k++)
              for (int i=1;i<=N;i++)
                  for (int j=1;j<=N;j++)
                      m[i][j]=m[i][j]||(m[i][k]&&m[k][j]);
          
          int part=0;
          int representative[MAXN+2];
          bool visited[MAXN+2];
          memset(visited,false,sizeof(visited));
          for (int i=1;i<=N;i++)
              if (!visited[i])
              {
                 representative[++part]=i;
                 visited[i]=true;
                 for (int j=1;j<=N;j++)
                     if (m[i][j]&&m[j][i])
                        visited[j]=true;
              }
          
          int indegree[MAXN+2];
          int outdegree[MAXN+2];
          memset(indegree,0,sizeof(indegree));
          memset(outdegree,0,sizeof(outdegree));
          for (int i=1;i<=part;i++)
              for (int j=1;j<=part;j++)
                  if (i!=j&&m[representative[i]][representative[j]])
                  {
                     indegree[j]++;
                     outdegree[i]++;
                  }
          int inTotal=0,outTotal=0;
          for (int i=1;i<=part;i++)
          {
              if (!indegree[i]) inTotal++;
              if (!outdegree[i]) outTotal++;
          }
          if (part>1) cout<<inTotal<<endl<<(inTotal>outTotal?inTotal:outTotal)<<endl;
          else cout<<1<<endl<<0<<endl;
          return 0;
      }
};

int main()
{
    Application app("schlnet.in","schlnet.out");
    return app.run();
}
