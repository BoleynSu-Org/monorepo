/*
ID: sujiao1
PROG: wissqu
LANG: C++
*/
/*
PROGRAM: wissqu
AUTHOR: Su Jiao
DATE: 2010-1-15
DESCRIPTION:
��˹�����ݵĴ������ˣ��Ǹð�С��ţ�Ǹϵ�С�����ϲ��Ѵ���ţ�Ǹϵ���γ 40 �ȵĴ���
���ϵ�ʱ���ˡ� 
ũ��Լ������������������ţ�������ڵ�����д�����������ţ��A����������ţ��B������
�︣��ţ��C�����ڰ���˹��ţ��D�����ʺն���ţ��E������Щ��ţȺ������һƬ 16 ӢĶ
�������ϣ�ÿӢĶ�϶���һСȺ��ţ���������������г� 4 x 4 �ĸ��ӣ����к��б�ţ��� 
  1 2 3 4
+-------
1|A B A C
2|D C D E
3|B E B C
4|C A D E
����������ϵ���ţȺ�ܹ��� 3 Ⱥ A��3 Ⱥ B��4 Ⱥ C��3 Ⱥ D��3 Ⱥ E������� D ��С
��ţ��ȥ���һȺ ��C ����һȺ������ 3 Ⱥ A��3 Ⱥ B��3 Ⱥ C��4 Ⱥ D��3 Ⱥ E�� 
ũ��Լ�������������ϵ���ţȺ�Ĳ��ַǳ�С�ġ�������Ϊ���ͬһ�����͵���ţȺ����̫
�������Ǿ����������Ǿۼ���դ�����ϳ��̣���ţ�̡������������ͬ�ĸ����ϻ������ٽ�
�� 8 �������ϣ����ǿ���̫���ˡ� 
ũ��Լ������������ɫ�ɸ���Ƥ�������Ĵ���ţȺ�˳���������������С��ţȺ�˽�������
Ƥ��һ��ֻ����һȺ��ţ����װ��һȺС��ţ��������С������һ�������У�ж����ȺС��
ţ����װ����������ϵ���Ⱥ����ţ��������γ 40 �ȵĴ�����ж���������ظ������Ĳ���
 16 �Σ�Ȼ�󿪳�ȥ�ܿ��̵�����֬���̵Ľ��׺ͼҾ�װ�ޡ� 
����ũ��Լ����������ѡ����ȷ��˳�����滻������ţȺ��ʹ�����Ӳ���һȺС��ţ���뵱
ǰ��ͬ��������ţռ�еķ�����ߵ�ǰ��ͬ��������ţռ�ݵķ�����ٽ����񡣵�Ȼ��һ��
����ţ���ˣ�С��ţ�ͱ����úã�in place����������С���Ժ�������Ҫ�����µ����а�
��ţȺ�ֿ��� 
�ǳ���Ҫ����ʾ��ũ��Լ���ӹ�ȥ�ľ���֪�������������ƶ� D ����ţȺ�� 
�ҳ�ũ��Լ��������С��ţ��Ǩ�����ǵ��������ϵİ취����� 16 �������� ��ţȺ����/
��/�� ����Ϣ��ʹ�������İ����ܹ����ϰ�ȫ���顣 
���� 4 x 4 �������������������Ͳ�����Щ���еķ�ʽ�������� 
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
      static const int N=4;
      char map[N+2][N+2];
      public:
      Application(char* input,char* output)
                        :cin(input),cout(output)
      {
                        for (int i=1;i<=N;i++)
                            for (int j=1;j<=N;j++)
                            {
                                cin>>map[i][j];
                                //cout<<map[j][i];
                                //if (j==N) cout<<endl;
                            }
      }
      ~Application()
      {
                    cin.close();
                    cout.close();
      }
      int total;
      bool put[N+2][N+2];
      int counter['Z'+2];
      char record[N*N+2];
      int rx[N*N+2],ry[N*N+2];
      /*
                      int xs=i>1?i-1:i;
                      int ys=j>1?j-1:j;
                      int xe=i<N?i+1:i;
                      int ye=j<N?j+1:j;
                      for (int x=xs;x<=xe;x++)
                          for (int y=ys;y<=ye;y++)
                              if (x!=i||y!=j)
                              {
                                 near[i][j][map[x][y]]=true;
                                 //cout<<"near["<<i<<","<<j<<"]:"<<map[x][y]<<endl;
                              }
      */
      void dfs(int step)
      {
           if (step==0)
           {
              total=0;
              memset(put,false,sizeof(put));
              counter['A']=counter['B']=counter['C']=counter['E']=3;
              counter['D']=4;                  
           }
           
           if (++step>N*N)
           {
              if (!total)
              for (int i=1;i<=N*N;i++) cout<<record[i]<<" "<<rx[i]<<" "<<ry[i]<<endl;
              total++;
           } 
           else
           {
               /*
               for (int i=1;i<=N;i++)
                   for (int j=1;j<=N;j++)
                       if (!put[i][j])
                       {
                          if (step==1)
                          {
                             char p='D';
                             if (counter[p]>0)
                             {
                                bool near=false;
                                int xs=i>1?i-1:i;
                                int ys=j>1?j-1:j;
                                int xe=i<N?i+1:i;
                                int ye=j<N?j+1:j;
                                for (int x=xs;!near&&(x<=xe);x++)
                                    for (int y=ys;!near&&(y<=ye);y++)
                                        if (map[x][y]==p)
                                           near=true;
                                
                                if (!near)
                                {
                                   record[step]=p;
                                   rx[step]=i;
                                   ry[step]=j;
                                   char backup=map[i][j];
                                   put[i][j]=true;
                                   counter[p]--;
                                   map[i][j]=p;
                                   dfs(step);
                                   map[i][j]=backup;
                                   counter[p]++;
                                   put[i][j]=false;
                                }
                             }
                          }
                          else
                          {
                              for (char p='A';p<='E';p++)
                                  if (counter[p]>0)
                                  {
                                     bool near=false;
                                     int xs=i>1?i-1:i;
                                     int ys=j>1?j-1:j;
                                     int xe=i<N?i+1:i;
                                     int ye=j<N?j+1:j;
                                     for (int x=xs;!near&&(x<=xe);x++)
                                         for (int y=ys;!near&&(y<=ye);y++)
                                             if (map[x][y]==p)
                                                near=true;
                                     
                                     if (!near)
                                     {
                                        record[step]=p;
                                        rx[step]=i;
                                        ry[step]=j;
                                        char backup=map[i][j];
                                        put[i][j]=true;
                                        counter[p]--;
                                        map[i][j]=p;
                                        dfs(step);
                                        map[i][j]=backup;
                                        counter[p]++;
                                        put[i][j]=false;
                                     }
                                  }
                          }
                       }
               */
                          if (step==1)
                          {
                             char p='D';
                             if (counter[p]>0)
                             {
               for (int i=1;i<=N;i++)
                   for (int j=1;j<=N;j++)
                       if (!put[i][j])
                       {
                                bool near=false;
                                int xs=i>1?i-1:i;
                                int ys=j>1?j-1:j;
                                int xe=i<N?i+1:i;
                                int ye=j<N?j+1:j;
                                for (int x=xs;!near&&(x<=xe);x++)
                                    for (int y=ys;!near&&(y<=ye);y++)
                                        if (map[x][y]==p)
                                           near=true;
                                
                                if (!near)
                                {
                                   record[step]=p;
                                   rx[step]=i;
                                   ry[step]=j;
                                   char backup=map[i][j];
                                   put[i][j]=true;
                                   counter[p]--;
                                   map[i][j]=p;
                                   dfs(step);
                                   map[i][j]=backup;
                                   counter[p]++;
                                   put[i][j]=false;
                                }
                       }
                             }
                          }
                          else
                          {
                              for (char p='A';p<='E';p++)
                                  if (counter[p]>0)
                                  {
               for (int i=1;i<=N;i++)
                   for (int j=1;j<=N;j++)
                       if (!put[i][j])
                       {
                                     bool near=false;
                                     int xs=i>1?i-1:i;
                                     int ys=j>1?j-1:j;
                                     int xe=i<N?i+1:i;
                                     int ye=j<N?j+1:j;
                                     for (int x=xs;!near&&(x<=xe);x++)
                                         for (int y=ys;!near&&(y<=ye);y++)
                                             if (map[x][y]==p)
                                                near=true;
                                     
                                     if (!near)
                                     {
                                        record[step]=p;
                                        rx[step]=i;
                                        ry[step]=j;
                                        char backup=map[i][j];
                                        put[i][j]=true;
                                        counter[p]--;
                                        map[i][j]=p;
                                        dfs(step);
                                        map[i][j]=backup;
                                        counter[p]++;
                                        put[i][j]=false;
                                     }
                       }
                                  }
                          }
           }
      }
      int run()
      {
          dfs(0);
          cout<<total<<endl;
          return 0;
      }
};

int main()
{
    Application app("wissqu.in","wissqu.out");
    return app.run();
}
