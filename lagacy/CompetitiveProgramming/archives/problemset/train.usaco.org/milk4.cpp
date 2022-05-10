/*
ID: sujiao1
PROG: milk4
LANG: C++
*/
/*
PROGRAM: milk4
AUTHOR: Su Jiao
DATE: 2010-1-15
DESCRIPTION:
ũ��Լ��Ҫ��ȡ Q��1 <= Q <= 20,000�����ѣ����ѣ�quarts���ݻ���λ��������ע�� ��
����õ�ţ�̣�������װ��һ����ƿ����������������Ҫ���٣����͸����٣��Ӳ����κ���
� 
ũ��Լ�����Ǻܽ�Լ������������ţ����̵깺��һЩͰ�����������ľ޴��ţ�̳�������
 Q ���ѵ�ţ�̡�ÿ��Ͱ�ļ۸�һ������������Ǽ����һ��ũ��Լ�����Թ�������ٵ�Ͱ
 �ļ��ϣ�ʹ���ܹ��պ�����ЩͰ���� Q ���ѵ�ţ�̡����⣬����ũ��Լ���������ЩͰ��
 �ؼң����ڸ�����������СͰ���ϣ�����ѡ�񡰸�С�ġ�һ�������������������ϰ�����
 ���򣬱Ƚϵ�һ��Ͱ��ѡ���һ��Ͱ�ݻ���С��һ���������һ��Ͱ��ͬ���Ƚϵڶ���Ͱ��
 Ҳ������ķ���ѡ�񡣷�����������Ĺ�����ֱ����Ƚϵ�����Ͱ��һ��Ϊֹ�����磬��
 �� {3��5��7��100} �ȼ��� {3��6��7��8} Ҫ�á� 
Ϊ������ţ�̣�ũ��Լ�����Դ�ţ�̳ذ�Ͱװ����Ȼ�󵹽�ƿ�ӡ���������ƿ�����ţ�̵�
�������߰�Ͱ���ţ�̵����𴦡���һ���ݻ�Ϊ 1 ���ѵ�Ͱ��ũ��Լ������ֻ�����Ͱ��
�����п��ܵĿ�������������Ͱ�����û����ô���㡣 
������Ҫ��������Ͱ������֤���еĲ������ݶ�������һ���⡣ 
*/
#include <fstream>
using std::ifstream;
using std::ofstream;
using std::endl;
#include <cstring>
using std::memset;
#include <algorithm>
using std::sort;

class Application
{
      ifstream cin;
      ofstream cout;
      static const int MAXP=100;
      static const int MAXW=20000;
      int Q,P;
      int w[MAXP+2];
      int p[MAXP+2];
      public:
      Application(char* input,char* output)
                        :cin(input),cout(output)
      {
                        cin>>Q>>P;
                        for (int i=1;i<=P;i++)
                            cin>>w[i];
      }
      ~Application()
      {
                    cin.close();
                    cout.close();
      }
      bool dp_can(const int& N)
      {
           bool f[MAXW+2];
           memset(f,false,sizeof(f));
           f[0]=true;
           for (int k=1;k<=N;k++)
               for (int i=p[k];i<=Q;i++)
                   f[i]=f[i]||f[i-p[k]];
           //for (int i=1;i<=N;i++) cout<<p[i]<<endl;
           //cout<<"end"<<f[Q]<<endl;
           return f[Q];
      }
      bool search(int step,int last,const int& MAXDEPTH)
      {
           if (++step>MAXDEPTH)
              return dp_can(MAXDEPTH);
           
           for (int i=last+1;i<=P;i++)
           {
               p[step]=w[i];
               if (search(step,i,MAXDEPTH)) return true;
           }
           return false;
      }
      int run()
      {
          sort(&w[1],&w[P]);
          for (int i=1;i<=P;i++)
              if (search(0,0,i))
              {
                 cout<<i;
                 for (int j=1;j<=i;j++)
                     cout<<" "<<p[j];
                 cout<<endl;
                 break;
              }
          return 0;
      }
};

int main()
{
    Application app("milk4.in","milk4.out");
    return app.run();
}
