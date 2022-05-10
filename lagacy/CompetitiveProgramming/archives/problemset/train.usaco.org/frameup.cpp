/*
ID: sujiao1
PROG: frameup
LANG: C++
*/
/*
PROGRAM: frameup
AUTHOR: Su Jiao
DATE: 2010-1-12
DESCRIPTION:
����������� 9 x 8 ��ͼ�� 
........   ........   ........   ........   .CCC....
EEEEEE..   ........   ........   ..BBBB..   .C.C....
E....E..   DDDDDD..   ........   ..B..B..   .C.C....
E....E..   D....D..   ........   ..B..B..   .CCC....
E....E..   D....D..   ....AAAA   ..B..B..   ........
E....E..   D....D..   ....A..A   ..BBBB..   ........
E....E..   DDDDDD..   ....A..A   ........   ........
E....E..   ........   ....AAAA   ........   ........
EEEEEE..   ........   ........   ........   ........
   1          2           3          4          5
���ڣ�����Щͼ���� 1��5 �ı�Ŵ��µ����ص����� 1 ���������棬�� 5 ������ˡ�
���һ��ͼ�񸲸�������һ��ͼ����ô���µ�ͼ���һ���־ͱ�ò��ɼ��ˡ����ǵõ���
���ͼ�� 
            .CCC....
           ECBCBB..
           DCBCDB..
           DCCC.B..
           D.B.ABAA
           D.BBBB.A
           DDDDAD.A
           E...AAAA
           EEEEEE..
��������һ��ͼ�񣬼��㹹������ͼ��ľ���ͼ��ӵײ������˶ѵ���˳�� 
�����������Ŀ�Ĺ��� 
���εıߵĿ��Ϊ 1 ��ÿ���ߵĳ��ȶ���С�� 3 �� 
���ε�ÿ�����У�������һ�����ǿɼ��ġ�ע�⣬һ����ͬʱ���������ߡ� 
�����ô�д��ĸ��ʾ������ÿ�����εı�ʾ���Ŷ�����ͬ�� 
*/
#include <fstream>
using std::ifstream;
using std::ofstream;
using std::endl;
#include <cstring>
using std::memset;
#include <string>
using std::string;

class Application
{
      ifstream cin;
      ofstream cout;
      static const int SET='z'+2;
      static char* const SETLIST;
      static const int MAXH=30;
      static const int MAXW=30;
      struct Box
      {
             int x1,x2,y1,y2;
             Box():x1(Application::MAXH),x2(0),y1(Application::MAXW),y2(0)
             {
             }
             void update(int x,int y)
             {
                  if (x2<x) x2=x;
                  if (x1>x) x1=x;
                  if (y2<y) y2=y;
                  if (y1>y) y1=y;
             }
      };
      int H,W;
      char pic[MAXH+2][MAXW+2];
      bool appear[SET];
      Box box[SET];
      char appearSet[SET];
      int  appearSet_len;
      bool cover[SET][SET];
      public:
      Application(char* input,char* output)
      :cin(input),cout(output)
      {
                              cin>>H>>W;
                              memset(appear,false,sizeof(appear));
                              appearSet_len=0;
                              for (int i=1;i<=H;i++)
                                  for (int j=1;j<=W;j++)
                                  {
                                      cin>>pic[i][j];
                                      if (pic[i][j]!='.')
                                      {
                                         if (!appear[pic[i][j]])
                                            appearSet[++appearSet_len]=pic[i][j];
                                         appear[pic[i][j]]=true;
                                      }
                                      box[pic[i][j]].update(i,j);
                                  }
                              /*
                              for (int i=1;i<=H;i++)
                              {
                                  for (int j=1;j<=W;j++)
                                      cout<<pic[i][j];
                                  cout<<endl;
                              }
                              for (char* i=SETLIST;*i;i++)
                              {
                                  if (appear[*i])
                                     cout<<*i<<":"<<box[*i].x1<<","<<box[*i].y1<<" "
                                                  <<box[*i].x2<<","<<box[*i].y2<<endl;
                                  //cout<<*i<<":"<<appear[*i]<<endl;
                              }
                              for (int i=1;i<=appearSet_len;i++)
                                  cout<<appearSet[i]<<endl;
                              */
      }
      ~Application()
      {
                    cin.close();
                    cout.close();
      }
      bool on(char a,char b)//a is on b ?
      {
           for (int i=box[b].x1;i<=box[b].x2;i++)
               if ((pic[i][box[b].y1]==a)||(pic[i][box[b].y2]==a)) return true;
           for (int i=box[b].y1;i<=box[b].y2;i++)
               if ((pic[box[b].x1][i]==a)||(pic[box[b].x2][i]==a)) return true;
           return false;
      }
      void initCover()
      {
           for (int i=1;i<=appearSet_len;i++)
               for (int j=i+1;j<=appearSet_len;j++)
                   if (appearSet[i]>appearSet[j])
                   {
                      char swap=appearSet[i];
                      appearSet[i]=appearSet[j];
                      appearSet[j]=swap;
                   }
           for (int i=1;i<=appearSet_len;i++)
               for (int j=1;j<=appearSet_len;j++)
                   cover[i][j]=(i!=j)&&on(appearSet[i],appearSet[j]);
           
           for (int k=1;k<=appearSet_len;k++)
               for (int i=1;i<=appearSet_len;i++)
                   for (int j=1;j<=appearSet_len;j++)
                       cover[i][j]=cover[i][j]||(cover[i][k]&&cover[k][j]);  
           /*
           for (int i=1;i<=appearSet_len;i++)
               for (int j=1;j<=appearSet_len;j++)
                   cout<<appearSet[i]<<appearSet[j]<<":"<<cover[i][j]<<endl;
           */
      }
      void dfs(int step)
      {
           static bool printed[SET];
           static char printList[SET];
           
           if (step==appearSet_len)
                cout<<printList<<endl;
           else
           {
               for (int j=1;j<=appearSet_len;j++)
                   if (!printed[j])
                   {
                      int degree=0;
                      for (int k=1;k<=appearSet_len;k++)
                          if ((!printed[k])&&(cover[j][k]))
                             degree++;
                      if (!degree)
                      {
                         printList[step]=appearSet[j];
                         printed[j]=true;
                         dfs(step+1);
                         printed[j]=false;
                      }
                   }
           }
      }
      void topologicalSort()
      {
           dfs(0);
      }
      int run()
      {
          initCover();
          topologicalSort();
          return 0;
      }
};
char* const Application::SETLIST="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

int main()
{
    Application app("frameup.in","frameup.out");
    return app.run();
}
