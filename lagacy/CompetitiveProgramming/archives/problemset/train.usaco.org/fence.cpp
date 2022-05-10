/*
ID: sujiao1
PROG: fence
LANG: C++
*/
/*
PROGRAM: fence
AUTHOR: Su Jiao
DATE: 2009-12-20
DESCRIPTION:
ũ��Johnÿ���кܶ�դ��Ҫ������������������ÿһ��դ�����޸�������ĵط��� 
John��һ��������ũ��һ�������ˡ�������������˴��������ξ���һ��դ����������
һ�����򣬶���դ��������������������һ����դ����·����ʹÿ��դ����ǡ�ñ�����һ
�Ρ�John�ܴ��κ�һ������(������դ���Ľ���)��ʼ����������һ����������� 
ÿһ��դ�������������㣬������1��500���(��Ȼ�е�ũ����û��500������)��һ������
�Ͽ����������(>=1)��դ��������դ��������ͨ��(Ҳ��������Դ�����һ��դ����������
������դ��)�� 
��ĳ��������������·��(��·�����ξ����Ķ�������ʾ)����������������·����
����һ��500���Ƶ�������ô�����ڶ���������£����500���Ʊ�ʾ������С��һ�� (Ҳ
���������һ������С�ģ�������ж���⣬����ڶ�������С�ģ��ȵ�)�� 
�������ݱ�֤������һ���⡣
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
      static const int MAXF=1024;
      static const int MAXN=500;
      int F;
      int map[MAXN+2][MAXN+2];
      int degree[MAXN+2];
      bool have[MAXN+2];
      int startPosition;
      public:
      Application(char* input,char* output)
      :cin(input),cout(output),startPosition(MAXN)
      {
                              memset(map,0,sizeof(map));
                              memset(degree,0,sizeof(degree));
                              memset(have,false,sizeof(have));
                              cin>>F;
                              for (int k=1;k<=F;k++)
                              {
                                  int i,j;
                                  cin>>i>>j;
                                  degree[i]++;
                                  degree[j]++;
                                  have[i]=true;
                                  have[j]=true;
                                  map[i][j]++;
                                  map[j][i]++;
                              }
                              bool find=false;
                              for (int i=1;i<=MAXN;i++)
                              {
                                  if (degree[i]%2==1)
                                  {
                                     startPosition=i;
                                     find=true;
                                     break;
                                  }
                              }
                              if (!find)
                              {
                                        for (int i=1;i<=MAXN;i++)
                                            if (have[i])
                                            {
                                               startPosition=i;
                                               break;
                                            }
                              }
      }
      ~Application()
      {
                    cin.close();
                    cout.close();
      }
      void go(int start)
      {
           int circuit[MAXF+2];
           int ctop;
           int stack[MAXF+2];
           int top;
           ctop=0;
           top=0;
           circuit[F]=start;
           stack[top]=start;
           
           while (ctop++<=F)
           {
                 int location=stack[top];
                 for (;;)
                 {
                     for (location=1;location<=MAXN;location++)
                         if (map[stack[top]][location]!=0) break;
                     if (location>MAXN) break;
                     map[stack[top]][location]--;
                     map[location][stack[top]]--;
                     stack[++top]=location;
                 }
                 circuit[ctop]=stack[top--];
           }
           
           for (int i=F+1;i>=1;i--)
               cout<<circuit[i]<<endl;
      }
      int run()
      {
          go(startPosition);
          return 0;
      }
};

int main()
{
    Application app("fence.in","fence.out");
    return app.run();
}
