//Boleyn Su's Template for Codeforces
#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>
#include <list>
#include <set>
#include <map>
#include <queue>
#include <deque>
#include <stack>
#include <algorithm>
#include <functional>
#include <utility>
#include <bitset>
#include <complex>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cmath>
#include <ctime>
#include <climits>
using namespace std;

#define lp for(;;)
#define rep(i,n) for (int i=0;i<(n);++i)
#define ft(i,a,b) for (int i=(a);i<=(b);++i)
#define fdt(i,a,b) for (int i=(a);i>=b;--i)
#define feach(e,s,t) for (t::itr e=(s).begin();e!=(s).end();++e)
#define fsubset(subset,set) for (int subset=set&(set-1);subset;subset=(subset-1)&set)
#define whl while
#define rtn return
#define fl(x,y) memset((x),char(y),sizeof(x))
#define clr(x) fl(x,0)
#define cpy(x,y) memcpy((x),(y),sizeof(x))
#define pb push_back
#define mp make_pair
#define x first
#define y second
#define sz(x) ((int)(x).size())
#define len(x) ((int)(x).length())
#define all(x) (x).begin(),(x).end()
#define srt(x) sort(all(x))
#define uniq(x) (x).resize(unique(all(x))-x.begin())
#define vec vector
#define pr pair
#define que queue
#define prq priority_queue
#define itr iterator
#define sf scanf
#define pf printf
#define pdb(prcs,x) printf("%."#prcs"f",(abs(x)<1e-##prcs)?0.0:x)
#define prt(x) cout<<#x<<"="<<(x)<<endl
#define asrtWA(s) do if(!(s))exit(0);whl(0)
#define asrtTLE(s) do if(!(s))whl(1);whl(0)
#define asrtMLE(s) do if(!(s))whl(new int);whl(0)
#define asrtOLE(s) do if(!(s))whl(1)puts("OLE");whl(0)
#define asrtRE(s) do if(!(s))*(int*)0=0;whl(0)
#define runtime() printf("Used: %.3fms\n",db(clock())/CLOCKS_PER_SEC);

typedef long long int lli;
typedef double db;
typedef char* cstr;
typedef string str;
typedef vec<int> vi;
typedef vec<vi> vvi;
typedef vec<bool> vb;
typedef vec<vb> vvb;
typedef vec<str> vs;
typedef pr<int, int> pii;
typedef pr<db,db> pdd;
typedef pr<str,int> psi;
typedef map<int,int> mii;
typedef map<str,int> msi;
typedef map<char,int> mci;
typedef set<int> si;
typedef set<str> ss;
typedef que<int> qi;
typedef prq<int> pqi;

const int oo=(~0u)>>1;
const lli ooll=(~0ull)>>1;
const db inf=1e+8;
const db eps=1e-8;
const db pi=acos(-1.0);
const int MOD=1000000007;

template<typename type>inline bool cmax(type& a,const type& b){rtn a<b?a=b,true:false;}
template<typename type>inline bool cmin(type& a,const type& b){rtn a>b?a=b,true:false;}
template<typename type>inline type sqr(const type& x){rtn x*x;}
int dbcmp(const db& a,const db& b){rtn (a>b+eps)-(a<b-eps);}
int sgn(const db& x){rtn dbcmp(x,0);}
template<typename type>inline type gcd(type a,type b){if(b)whl((a%=b)&&(b%=a));rtn a+b;}
template<typename type>inline type lcm(type a,type b){rtn a*b/gcd(a,b);}
template<typename type>inline void bit_inc(vec<type>& st,int x,type inc){whl(x<sz(st))st[x]+=inc,x|=x+1;}
template<typename type>inline type bit_sum(const vec<type>& st,int x){type s=0;whl(x>=0)s+=st[x],x=(x&(x+1))-1;rtn s;}
inline void make_set(vi& set,int size){set.resize(size);rep(i,size)set[i]=i;}
inline int find_set(vi& set,int x){int y=x,z;whl(y!=set[y])y=set[y];whl(x!=set[x])z=set[x],set[x]=y,x=z;rtn y;}
inline bool union_set(vi& set,int a,int b){a=find_set(set,a),b=find_set(set,b);rtn a!=b?set[a]=b,true:false;}
/*
Package:
图论.网络流.最大流

Description:
SAP实现的最大流

Interface:
MAXV:{
需要为点分配多少空间
Warning:
点不一定要从0到V-1，即MAXV应该等于实际最大的标号+1
}
MAXE:{
需要为边分配多少空间
Warning:
一条边对应一条正向边和一条反向边，即注意MAXE要等于实际最大边数*2
}
add_edge:{
输入int u,v,c
add_edge(u,v,c) 加一条u到v的容量为c的有向边
}
build_network:{
构图
详细见函数内的注释
}
sap:{
输出int
sap()=最大流
}

Include:
#include <my_template_for_codeforces>

Test:
已经测过许多数据，可信任

References:
ZKW's Lab(http://www.artofproblemsolving.com/blog/54266)

Latest Update:
2012-09-19
*/
enum{MAXV=2000,MAXE=50000};
typedef struct struct_edge* edge;
struct struct_edge{int v,c;edge n,b;};
struct_edge pool[MAXE];
edge top;
int S,T,V;
edge adj[MAXV];
void add_edge(int u,int v,int c)
{
     top->v=v,top->c=c,top->n=adj[u],adj[u]=top++;
     top->v=u,top->c=0,top->n=adj[v],adj[v]=top++;
     adj[u]->b=adj[v],adj[v]->b=adj[u];
}
void build_network()
{
     fl(adj,0),top=pool;
     //S,T,V;//源，汇，点数
     //Warning:
     //V必须严格等于图中的点的数目
     //add_edge(u,v,c);
}
edge cur[MAXV];
int pre[MAXV],d[MAXV],dn[MAXV+1],q[MAXV],qh,qt;
int sap()
{
    rep(i,MAXV) d[i]=V;
    clr(dn),cpy(cur,adj),d[q[qh=qt=0]=T]=0,dn[V]=V;
    whl(qh<=qt)
    {
        int u=q[qh++];
        dn[d[u]]++,dn[V]--;
        for (edge i=adj[u];i;i=i->n)
            if ((d[i->v]==V)&&i->b->c)
                d[q[++qt]=i->v]=d[u]+1;
    }
    int f=0,u=S;
    whl(d[S]<V)
    {
        if (u==T)
        {
            int aug=+oo,v;
            v=T;
            whl(v!=S) cmin(aug,cur[v=pre[v]]->c);
            v=T;
            whl(v!=S) v=pre[v],cur[v]->c-=aug,cur[v]->b->c+=aug,u=cur[v]->c?u:v;
            f+=aug;
        }
        whl(cur[u]&&!(cur[u]->c&&d[u]==d[cur[u]->v]+1)) cur[u]=cur[u]->n;
        if (cur[u]) pre[cur[u]->v]=u,u=cur[u]->v;
        else
        {
            int mind=V;
            for (edge i=adj[u];i;i=i->n)
                if (i->c&&cmin(mind,d[i->v])) cur[u]=i;
            if (!(--dn[d[u]])) break;
            dn[d[u]=mind+1]++;
            if (u!=S) u=pre[u];
        }
    }
    return f;
}

int main()
{cin.sync_with_stdio(false);cout.sync_with_stdio(false);
	int n,b;
	cin>>n>>b;
	vvi m(n,vi(b));
	rep(i,n) rep(j,b) cin>>m[i][j];
	vi c(b);
	rep(i,b) cin>>c[i];
	rep(ans,b)
	{
	    for (int min=1;min+ans<=b;min++)
	    {
	    	int max=min+ans;
	    	build_network();
	    	S=n+b,T=n+b+1,V=n+b+2;
	    	rep(i,n) add_edge(S,i,1);
	    	rep(i,b) add_edge(n+i,T,c[i]);
	    	rep(i,n) ft(j,min,max) add_edge(i,n+m[i][j-1]-1,+oo);
	    	if (sap()==n) rtn cout<<ans+1<<endl,0;
	    }
	}
}