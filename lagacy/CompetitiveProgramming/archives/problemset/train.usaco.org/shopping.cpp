/*
ID: sujiao1
PROG: shopping
LANG: C++
*/
/*
PROGRAM: shopping
AUTHOR: Su Jiao
DATE: 2009-12-21
DESCRIPTION:
���� 
���̵��У�ÿһ����Ʒ����һ���۸���������ʾ��������,һ�仨�ļ۸��� 
2 zorkmids ��z������һ����ƿ�ļ۸��� 5z ��Ϊ����������Ĺ˿ͣ��̵�����˴�
����� 
�������һ��������Ʒ��������������ۣ����磺 
���仨�ļ۸��� 5z ������ 6z�� ������ƿ��һ�仨�ļ۸��� 10z ������ 12z�� 
��дһ�����򣬼���˿͹���һ����Ʒ�Ļ��ѣ����������Ż�ʹ�������١�������
ʱ�����������Ʒ���Ի�ø��ٵĻ��ѣ������㲻����ô���� 
�����������Ʒ��Ϣ���������仨��������ƿ�����ٻ����ǣ����Żݼ۹���������
ƿ��һ�仨��10z������ԭ�۹������仨��4z���� 
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
      static const int MAXP=9999;
      static const int MAXS=99;
      static const int MAXN=5;
      static const int MAXC=999;
      static const int MAXB=5;
      static const int MAXK=5;
      static const int oo=MAXP*MAXK*MAXB;
      int xk_len;
      int xk[MAXS+MAXB][MAXB];
      int vk[MAXS+MAXB];
      int counter[MAXS+MAXB];
      int target[MAXB];
      int f[MAXK+2][MAXK+2][MAXK+2][MAXK+2][MAXK+2];
      public:
      Application(char* input,char* output)
      :cin(input),cout(output)
      {
                              int s;
                              int n[MAXS+2];
                              int c[MAXS+2][MAXN+2];
                              int k[MAXS+2][MAXN+2];
                              int p[MAXS+2];
                              int b;
                              int _c[MAXB+2];
                              int _k[MAXB+2];
                              int _p[MAXB+2];
                              cin>>s;
                              for (int i=1;i<=s;i++)
                              {
                                  cin>>n[i];
                                  for (int j=1;j<=n[i];j++)
                                      cin>>c[i][j]>>k[i][j];
                                  cin>>p[i];
                              }
                              cin>>b;
                              for (int i=1;i<=b;i++)
                                  cin>>_c[i]>>_k[i]>>_p[i];
                              
                              int id[MAXC+2];
                              memset(id,0,sizeof(MAXC));
                              for (int i=1;i<=b;i++)
                                  id[_c[i]]=i;
                              
                              xk_len=0;
                              memset(xk,0,sizeof(xk));
                              memset(vk,0,sizeof(vk));
                              for (int i=1;i<=s;i++)
                              {
                                  bool can=true;
                                  for (int j=1;j<=n[i];j++)
                                      if (id[c[i][j]]==0)
                                         can=false;
                                  if (can)
                                  {
                                     for (int j=1;j<=n[i];j++)
                                         xk[xk_len][id[c[i][j]]-1]=k[i][j];
                                     vk[xk_len]=p[i];
                                     xk_len++;
                                  }
                              }
                              for (int i=1;i<=b;i++)
                              {
                                  xk[xk_len][id[_c[i]]-1]=1;
                                  vk[xk_len]=_p[i];
                                  xk_len++;
                              }
                              /*
                              for (int i=0;i<xk_len;i++)
                              {
                                  for (int j=0;j<b;j++)
                                      cout<<xk[i][j]<<" ";
                                  cout<<"price: "<<vk[i]<<endl;
                              }
                              */
                              memset(target,0,sizeof(target));
                              for (int i=1;i<=b;i++)
                                  target[id[_c[i]]-1]=_k[i];
                              /*
                              for (int i=0;i<b;i++)
                                  cout<<target[i]<<" ";
                              cout<<endl;
                              */
                              
      }
      ~Application()
      {
                    cin.close();
                    cout.close();
      }
      int dp(int tar[MAXB])
      {
          
          bool get=true;
          for (int i=0;i<MAXB;i++)
          {
              if (tar[i]>0) get=false;
              if (tar[i]<0) tar[i]=0;
          }
          if (get) return 0;
          if (f[tar[0]][tar[1]][tar[2]][tar[3]][tar[4]]!=0)
             return f[tar[0]][tar[1]][tar[2]][tar[3]][tar[4]];
          
          f[tar[0]][tar[1]][tar[2]][tar[3]][tar[4]]=oo;
          for (int i=0;i<xk_len;i++)
          {
              int ntar[MAXB];
              for (int j=0;j<MAXB;j++)
                  ntar[j]=tar[j]-xk[i][j];
              int f_sk_1=dp(ntar);
              if (f_sk_1+vk[i]<f[tar[0]][tar[1]][tar[2]][tar[3]][tar[4]])
                 f[tar[0]][tar[1]][tar[2]][tar[3]][tar[4]]=f_sk_1+vk[i];
          }
          /*
          cout<<"( ";
          for (int i=0;i<MAXB;i++)
              cout<<tar[i]<<" ";
          cout<<")="<<f[tar[0]][tar[1]][tar[2]][tar[3]][tar[4]]<<endl;
          */
          return f[tar[0]][tar[1]][tar[2]][tar[3]][tar[4]];
      }
      int run()
      {
          memset(f,0,sizeof(f));
          memset(counter,0,sizeof(counter));
          cout<<dp(target)<<endl;
          return 0;
      }
};

int main()
{
    Application app("shopping.in","shopping.out");
    return app.run();
}
