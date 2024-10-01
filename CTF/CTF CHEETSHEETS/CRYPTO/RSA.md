

https://ir0nstone.gitbook.io/crypto/rsa/overview



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



wiener attack




