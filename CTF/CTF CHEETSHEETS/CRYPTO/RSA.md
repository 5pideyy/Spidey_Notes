





# Public Exponent Attacks

### Small e
The content from the URL discusses attacks on RSA encryption when the public exponent (e) is small. Here's a summary:

When eee (the exponent) is very small, it may be ineffective at encrypting the message mmm. If me<Nm^e < Nme<N (where NNN is the modulus), we can directly compute the eee-th root of the ciphertext ccc to recover the message.

For example, if e=3e = 3e=3, we can calculate m=c3m = \sqrt[3]{c}m=3c​. However, if me>Nm^e > Nme>N, it's slightly more secure. We can still attack this by progressively adding multiples of NNN until the cube root gives a valid answer.

In Python, this can be done using the `gmpy3` library's `iroot` function.

Let me know if you need more details or further analysis!


### multi party with samll e 


The page you referred to discusses an attack on RSA when the public exponent eee is small and the same message is sent to multiple recipients.

If the public exponent eee is constant across messages and the same message mmm is sent to at least eee different recipients, the Chinese Remainder Theorem (CRT) can be used to recover the original message.

In single-party RSA, c=memod  Nc = m^e \mod Nc=memodN. When sending to multiple recipients with different moduli (N1,N2,N3N_1, N_2, N_3N1​,N2​,N3​, etc.), CRT allows us to solve the system of congruences, and as long as m<min⁡(N1,N2,N3)m < \min(N_1, N_2, N_3)m<min(N1​,N2​,N3​), we can compute memod  N1N2N3m^e \mod N_1 N_2 N_3memodN1​N2​N3​, and then take the eee-th root to recover mmm.



### wiener attack



Using Continued Fractions to attack large e values

## 

[](https://ir0nstone.gitbook.io/crypto/rsa/public-exponent-attacks/wieners-attack#overview)

Overview

Wiener's Attack utilises the convergents of the continued fraction expansion of kddk​ to attempt to guess the decryption exponent dd when ee is large, as dd is necessarily small as a result.

## 

[](https://ir0nstone.gitbook.io/crypto/rsa/public-exponent-attacks/wieners-attack#introduction)

Introduction

We can say that

ϕ(N)=(p−1)(q−1)=pq−(p+q)+1≈Nϕ(N)=(p−1)(q−1)=pq−(p+q)+1≈N

​We can also say that since ed≡1mod  ϕ(N)ed≡1modϕ(N)​, we can rearrange this to say that ed=kϕ(N)+1ed=kϕ(N)+1.

d=kϕ(N)+1ed−kϕ(N)=1eϕ(N)−kd=1dϕ(N)d=kϕ(N)+1ed−kϕ(N)=1ϕ(N)e​−dk​=dϕ(N)1​

Now since dϕ(N)dϕ(N) is likely to be huge, we can say 1dϕ(N)dϕ(N)1​ is almost zero, and also use the approximation from before to say that

eN≈kdNe​≈dk​

Note that eNNe​ is composed of **entirely public information**, meaning we have access to an approximation to kddk​, which is **entirely private information**.

## 

[](https://ir0nstone.gitbook.io/crypto/rsa/public-exponent-attacks/wieners-attack#determining-the-private-information)

Determining the Private Information

We can represent eNNe​ as a continued fraction. If we go through the convergents of this fraction, we may come across kddk​ since eN≈kdNe​≈dk​ (kddk​ is a good approximation). This is more likely to work whendis smaller due to **Legendre’s Theorem in Diophantine Approximations** (TODO prove this), specifically when d<13N14d<31​N41​.

Once we list the convergents, we iterate through and there are a few checks we can make to determine whether or not it's the correct convergent:

- As ed≡1mod  ϕ(N)ed≡1modϕ(N) and ϕ(N)ϕ(N) is even, dd must be odd, so we can discard convergences with even denominators.
    
- Since ϕ(N)ϕ(N) must be a whole number, we can compute ed−1kked−1​ and see if it returns an integer or not - if not, we can discard the convergent.
    

Once we find a convergent we don't discard, we can assume it's ϕ(N)ϕ(N) and attempt to calculate dd with that, seeing if the resultant private key yields a valid result or not. This can take a **lot** of decryption attempts to work successfully however - we can speed up the "checking" process using a quadratic equation.

### 

[](https://ir0nstone.gitbook.io/crypto/rsa/public-exponent-attacks/wieners-attack#solving-for-p-q)

Solving for p, q

If we say N=pqN=pq, it follows that:

ϕ(N)=(p−1)(q−1)ϕ(N)=N−(p+q)+1p+q=N−ϕ(N)+1ϕ(N)=(p−1)(q−1)ϕ(N)=N−(p+q)+1p+q=N−ϕ(N)+1

If we now consider a quadratic equation (x−p)(x−q)=0(x−p)(x−q)=0, with the roots pp and qq being the prime factors of NN, we can expand this and substitute:

(x−p)(x−q)=0x2−(p+q)x+pq=0x2−(N−ϕ(N)+1)x+N=0(x−p)(x−q)=0x2−(p+q)x+pq=0x2−(N−ϕ(N)+1)x+N=0

If our value of ϕ(N)ϕ(N) is correct, we can substitute this into the equation and solve it for two integer values pp and qq. If the values are not integer, the result can be discarded.
\\\


# Choice of Primes

When NN is prime, ϕ(N)=N−1ϕ(N)=N−1. This makes decryption super simple.


[Mersenne Primes](https://en.wikipedia.org/wiki/Mersenne_prime) take the form p=2k−1p=2k−1. Often we just loop through all possible Mersenne primes and check if either pp or qq are that.

This is very easy to do in Sage:

Copy

```
from sage.combinat.sloane_functions import A000668

mersenne = A000668()
```

Then we can grab the nnth Mersenne prime using `mersenne(n)`.



## P=Q

If p=qp=q then N=pq=p2N=pq=p2 and you can use function such as `isqrt` in Python to retrieve pp.

Note that in the situation N=p2N=p2, ϕ(N)≠(p−1)2ϕ(N)=(p−1)2 due to the full definition of Euler's totient function:

ϕ(n)=n∏p∣n(1−1p)ϕ(n)=np∣n∏​(1−p1​)

The key here is that p∣np∣n are **distinct** prime factors, so we would only use pp once in the equation:

ϕ(n)=n(1−1p)=n−pϕ(n)=n(1−p1​)=n−p


# Fermat Factorisation

Used when p and q are numericaly close

If pp and qq are numerically close, we can use [Fermat Factorisation](https://en.wikipedia.org/wiki/Fermat%27s_factorization_method).

During Fermat Factorisation, we hope to find aa and bb such that

a2−b2=Na2−b2=N

Because that then means we can factorise the left-hand expression into

(a+b)(a−b)=N(a+b)(a−b)=N

As thus we get the two factors of NN as (a+b)(a+b) and (a−b)(a−b).

The reason we use this when pp and $q$ are numerically close is because the closer they are to each other the closer they are to NN​. If we say a=Na=N​ rounded up to the nearest number, we can calculate b2=a2−Nb2=a2−N (as rearranged from before) until bb is a whole number, after which we've solved the equation.

An example of this attack can be found in [this writeup](https://www.notion.so/Factorize-b96056dc70f54cc7b42b32f8984cb7cf), which may make it a bit clearer.
























