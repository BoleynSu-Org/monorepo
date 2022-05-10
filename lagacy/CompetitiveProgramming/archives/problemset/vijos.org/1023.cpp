#include <iostream>
#include <string>
using namespace std;

const int MAXN=200;
int link[MAXN+2][MAXN+2];
bool in[MAXN+2]; 
int n;
bool visited[MAXN+2];

void visit(int node)
{
     visited[node]=true;
     for (int i=1;i<=link[node][0];i++)
         if (!visited[link[node][i]])
            visit(link[node][i]);
}

int main()
{
    cin>>n;
    for (int i=1;i<=n;i++)
        for (link[i][0]=0;;)
        {
            int get;
            cin>>get;
            if (get==0) break;
            link[i][++link[i][0]]=get;
            in[get]=true;
        }
    int answer=0;
    
    //���Ϊ0�� һ��Ҫֱ�ӷ��� 
    for (int i=1;i<=n;i++)
        if (!in[i])
        {
           answer++;
           visit(i);
        }
    //��Ȳ�Ϊ0�� һ��ǿ��ͨ��ͼ������һ���ڵ㱻���� 
    for (int i=1;i<=n;i++)
    {
        if (!visited[i])
        {
           answer++;
           visit(i);
        }
    }
    cout<<answer<<endl;
    return 0;
}
