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
#define vec vector
#define pr pair
#define que queue
#define prq priority_queue
#define itr iterator
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
inline int find_set(vi& set,int x){if(set[x]!=x)set[x]=find_set(set,set[x]);rtn set[x];}
inline bool union_set(vi& set,int a,int b){a=find_set(set,a),b=find_set(set,b);rtn a==b?false:set[a]=b,true;}
/*
int main()
{
    typedef lli T;
    pr<T,T> a,b,c;
    cin>>a.x>>a.y>>b.x>>b.y>>c.x>>c.y;
    lli cross=(a.x-b.x)*(c.y-b.y)-(a.y-b.y)*(c.x-b.x);
    prt(a.x-b.x),prt(c.y-b.y);
    prt(a.y-b.y),prt(c.x-b.x);
    prt((a.y-b.y)*(c.x-b.x));
    prt(cross);
    if (cross==0) cout<<"TOWARDS"<<endl;
    else if (cross>0) cout<<"RIGHT"<<endl;
    else cout<<"LEFT"<<endl;
}
*/
/*
int main()
{
    int n;
    cin>>n;
    mii f;
    ft(i,1,n)
    {
        int ai;
        cin>>ai;
        f[ai]=i;
    }
    int m;
    cin>>m;
    lli ac=0,bc=0;
    rep(i,m)
    {
        int x;
        cin>>x;
        ac+=f[x];
        bc+=n+1-f[x];
    }
    cout<<ac<<" "<<bc<<endl;
}
*/
/*
lli pow(lli a,lli b,lli c)
{
    lli d=1;
    whl(b)
    {
        if (b&1ll) d*=a,d%=c;
        a*=a,a%=c;
        b>>=1;
        //prt(a),prt(b),prt(d);
    }
    rtn d;
}
int main()
{
    lli n,m;
    cin>>n>>m;
    cout<<(pow(3ll,n,m)+m-1ll)%m<<endl;
}
*/
/*
vec<vec<lli> > mul(const vec<vec<lli> >& a,const vec<vec<lli> >& b,lli MOD)
{
    vec<vec<lli> > c(a.size(),vec<lli>(b[0].size(),0));
    rep(i,a.size())
        rep(j,b[0].size())
            rep(k,b.size())
            {
                c[i][j]+=lli(a[i][k])*lli(b[k][j])%MOD;
                c[i][j]%=MOD;
            }
    return c;
}
vec<vec<lli> > pow(const vec<vec<lli> >& a,lli b,lli MOD)
{
    vec<vec<lli> > t=a;
    vec<vec<lli> > c(a.size(),vec<lli>(a.size(),0));
    rep(i,a.size()) c[i][i]=1;
    while (b)
    {
        if (b&1) c=mul(c,t,MOD);
        t=mul(t,t,MOD);
        b>>=1;
    }
    return c;
}

int main()
{
    lli m,l,r,k;
    vec<vec<lli> > a(2,vec<lli>(2));
    a[0][0]=a[1][0]=a[0][1]=1;
    //lli n;
    //whl(cin>>n) prt(pow(a,n,1000)[0][1]);
    cin>>m>>l>>r>>k;

    lli L=1,R=r+1;
    whl(L+1!=R)
    {
        lli mid=(L+R)>>1;
        if (l<=mid&&mid*k<=r) L=mid;
        else R=mid;
    }
    cout<<pow(a,L,m)[0][1]<<endl;
}
*/
lli a[1000000];
int main()
{
    int n;
    scanf("%d",&n);
    rep(i,n) scanf("%I64d",a+i);
    sort(a,a+n,greater<lli>());
    vec<lli> sum(n);
    rep(i,n) sum[i]=(i?sum[i-1]:0)+a[i];
    vec<lli> ss(n);
    rep(i,n) ss[i]=(i?ss[i-1]:0)+a[i]*i;
    n--;
    int q;
    scanf("%d",&q);
    rep(i,q)
    {
        lli k;
        lli ans=0;
        scanf("%I64d",&k);
        if (k==1)
        {
            printf("%I64d%c",ss[n],char(i+1==q?'\n':' '));
            continue;
        }
        lli l=0,kk=1,c=0;
        lp
        {
            lli r=l-1+kk;
            if (r>n) r=n;
            ans+=(sum[r]-(l?sum[l-1]:0))*c;
            if (r==n) break;
            l=l*k+1,kk=kk*k,c++;
        }
        printf("%I64d%c",ans,char(i+1==q?'\n':' '));
    }
}
