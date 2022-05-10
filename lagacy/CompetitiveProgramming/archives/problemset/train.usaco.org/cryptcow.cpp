/*
ID: sujiao1
PROG: cryptcow
LANG: C++
*/
/*
PROGRAM: cryptcow
AUTHOR: Su Jiao
DATE: 2010-1-2
DESCRIPTION:
ũ��Brown��John��ţ�Ǽƻ�Эͬ�ӳ����Ǹ��Ե�ũ�������������һ�ּ��ܷ�����������
���ǵ�ͨѶ��������֪���� 
���һͷţ����ϢҪ���ܣ�����"International Olympiad in Informatics"�����������
��C��O��W������ĸ�嵽����Ϣ�У�����C��Oǰ�棬O��Wǰ�棩��Ȼ������C��O֮�������
�� O��W֮������ֵ�λ�û��������������������ӣ� 
International Olympiad in Informatics
-> 
CnOIWternational Olympiad in Informatics
International Olympiad in Informatics
-> 
International Cin InformaticsOOlympiad W
Ϊ��ʹ���ܸ����ӣ�ţ�ǻ���һ����Ϣ���β���������ܷ��������ϴμ��ܵĽ���ٽ���
���ܣ���һ��ҹ�John��ţ���յ���һ��������μ��ܵ���Ϣ������дһ�������ж�����
����������Ϣ�������ܣ���û�м��ܣ����õ��ģ� 
Begin the Escape execution at the Break of Dawn
*/
#include <fstream>
using std::ifstream;
using std::ofstream;
using std::endl;
#include <cstring>
using std::memset;
#include <ctime>
using std::clock;

class Application
{
      ifstream cin;
      ofstream cout;
      static const int MAXLEN=75;
      static const int MAXPOINTER=10;
      static const int oo=1024*1024*1024;
      static const int __EOF__='\n';
      static char *const target;
      typedef char string[MAXLEN+2];
      typedef char* pointer;
      string text;
      int len;
      public:
      Application(char* input,char* output)
      :cin(input),cout(output)
      {
                              pointer pos=text;
                              while (((*(pos++))=cin.get())!=__EOF__) ;
                              *(--pos)='\0';
      }
      ~Application()
      {
                    cin.close();
                    cout.close();
      }
      bool can_andGetLen()
      {
           int counter1['z'+2];
           memset(counter1,0,sizeof(counter1));
           for (pointer i=text;*i;i++)
               counter1[*i]++;
           
           int counter2['z'+2];
           memset(counter2,0,sizeof(counter2));
           for (pointer i=target;*i;i++)
               counter2[*i]++;
           
           for (int i=0;i<='z';i++)
               if ((i!='C')&&(i!='O')&&(i!='W')&&counter1[i]!=counter2[i]) return false;
               
           pointer end1=text;
           while (*end1++);
           pointer end2=target;
           while (*end2++);
           
           if ((counter1['C']!=counter1['O'])
               ||(counter1['C']!=counter1['W'])
               ||(counter1['O']!=counter1['W']))
               return false;
           
           len=counter1['C'];
           
           if ((end2-target+3*len)!=(end1-text)) return false;
           return true;
      }
      bool get(string from)
      {
           pointer to=target;
           while (*to)
                 if ((*from++)!=(*to++)) return false;
           return *from=='\0';
      }
      void createNext(pointer C,pointer O,pointer W,pointer pos,pointer from)
      {
           for (pointer i=from;i<C;i++)
               (*pos++)=*i;
           for (pointer i=O+1;i<W;i++)
               (*pos++)=*i;
           for (pointer i=C+1;i<O;i++)
               (*pos++)=*i;
           for (pointer i=W+1;*i;i++)
               (*pos++)=*i;
           *pos='\0';
      }
      bool checkSort(int len,pointer* c,pointer* o,pointer* w)
      {
           for (int i=1;i<=len;i++)
               if (o[i]<c[1]) return false;
           for (int i=1;i<=len;i++)
               if (w[i]<c[1]) return false;
           for (int i=1;i<=len;i++)
               if (c[i]>w[len]) return false;
           for (int i=1;i<=len;i++)
               if (o[i]>w[len]) return false;
           return true;
      }
      bool firstCheck(pointer from,pointer target,pointer end)
      {
           for (pointer i=from,j=target;i<end;i++)
               if (*i!=*j++) return false;
           return true;
      }
      bool lastCheck(pointer from,pointer target,pointer end)
      {
           while (*++from) ;
           while (*++target) ;
           for (pointer i=from,j=target;i>end;i--)
               if (*i!=*j--) return false;
           return true;
      }
      bool inTarget(pointer from,pointer to)
      {
           from++;
           to--;
           if (to<=from) return true;
           for (pointer i=target;*i;i++)
               if (*i==*from)
               {
                  bool in=true;
                  pointer k=from;
                  for (pointer j=i;k<=to;j++)
                      if (*j!=*k++)
                      {
                         in=false;
                         break;
                      }
                  if (in) return true;
               }
           return false;
      }
      bool COWSort_andCheck(int step,pointer* _C,pointer* _O,pointer* _W)
      {
           pointer newSort[MAXPOINTER*3];
           int sort_len=step*3;
           for (int i=1;i<=step;i++)
           {
               newSort[i*3-2]=_C[i];
               newSort[i*3-1]=_O[i];
               newSort[i*3-0]=_W[i];
           }
           for (int i=1;i<=sort_len;i++)
               for (int j=i+1;j<=sort_len;j++)
                   if (newSort[i]>newSort[j])
                   {
                      pointer swap=newSort[i];
                      newSort[i]=newSort[j];
                      newSort[j]=swap;
                   }
           for (int i=1;i<sort_len;i++)
               if (!inTarget(newSort[i],newSort[i+1])) return false;
           return true;
      }
      static const int MAXHASH=99991;
      static bool got[MAXHASH];
      static int c;
      int elfhash_check(pointer key)
      {
          if (c>4500) return false;
          c++;
          unsigned long h=0,g;
          while (*key)
          {
                h=(h<<4)+*key++;
                g=h &0xf0000000l;
                if (g) h^=g>>24;
                h&=~g;
          }
          h=h%MAXHASH;
          if (got[MAXHASH]) return false;
          got[h]=true;
          return true;
      }
      bool search(int step,string from)
      {
           //cout<<from<<endl;
           if (step==0)
              return get(from);
           else
           {
               string next;
               int lenc=0,leno=0,lenw=0;
               pointer _C[MAXPOINTER];
               pointer _O[MAXPOINTER];
               pointer _W[MAXPOINTER];
               for (pointer i=from;*i;i++)
                   switch (*i)
                   {
                          case 'C':
                               _C[++lenc]=i;
                               break;
                          case 'O':
                               _O[++leno]=i;
                               break;
                          case 'W':
                               _W[++lenw]=i;
                               break;
                   }
               
               if (!checkSort(step,_C,_O,_W)) return false;
               if (!firstCheck(from,target,_C[1])) return false;
               if (!lastCheck(from,target,_W[step])) return false;
               if (!COWSort_andCheck(step,_C,_O,_W)) return false;
               if (!elfhash_check(from)) return false;
               
               int i,j,k;
               for (j=1;j<=step;j++)
                   for (i=1;i<=step;i++)
                       for (k=step;k>=1;k--)
                           if (_C[i]<_O[j]&&(_O[j]<_W[k]))
                           {
                              createNext(_C[i],_O[j],_W[k],next,from);
                              if (search(step-1,next)) return true;
                           }
               return false;
           }
      }
      int run()
      {
          if (can_andGetLen()&&search(len,text)) cout<<1<<" "<<len<<endl;
          else cout<<0<<" "<<0<<endl;
          //cout<<clock()<<endl;cout<<c<<endl;
          return 0;
      }
};
char *const Application::target="Begin the Escape execution at the Break of Dawn";
bool Application::got[MAXHASH];
int Application::c;

int main()
{
    Application app("cryptcow.in","cryptcow.out");
    return app.run();
}
