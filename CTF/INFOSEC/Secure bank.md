
https://ch2016112962.challenges.eng.run/user/0?secret=31733100

![[Pasted image 20250111140821.png]]



```
public class HashReversal {

    // Hash function
    public static Long hash(Long l) {
        Long valueOf = Long.valueOf(((l.longValue() & 2863311530L) >>> 1) | ((l.longValue() & 1431655765) << 1));
        Long valueOf2 = Long.valueOf(((valueOf.longValue() & 3435973836L) >>> 2) | ((valueOf.longValue() & 858993459) << 2));
        Long valueOf3 = Long.valueOf(((valueOf2.longValue() & 4042322160L) >>> 4) | ((valueOf2.longValue() & 252645135) << 4));
        Long valueOf4 = Long.valueOf(((valueOf3.longValue() & 4278255360L) >>> 8) | ((valueOf3.longValue() & 16711935) << 8));
        return Long.valueOf((valueOf4.longValue() >>> 16) | (valueOf4.longValue() << 16));
    }

    // Reverse hash function
    public static Long reverseHash(Long hash) {
        // Reverse the 16-bit shift
        Long valueOf4 = Long.valueOf((hash << 16) | (hash >>> 16));

        // Reverse the 8-bit shift
        Long valueOf3 = Long.valueOf(((valueOf4 & 16711935L) << 8) | ((valueOf4 & 4278255360L) >>> 8));

        // Reverse the 4-bit shift
        Long valueOf2 = Long.valueOf(((valueOf3 & 252645135L) << 4) | ((valueOf3 & 4042322160L) >>> 4));

        // Reverse the 2-bit shift
        Long valueOf = Long.valueOf(((valueOf2 & 858993459L) << 2) | ((valueOf2 & 3435973836L) >>> 2));

        // Reverse the 1-bit shift
        Long original = Long.valueOf(((valueOf & 1431655765L) << 1) | ((valueOf & 2863311530L) >>> 1));

        return original;
    }

    public static void main(String[] args) {
        // Hash values to decrypt
        Long[] hashes = {
            216406515827922L,
            43431626549120L,
            13348376939555L,
            240658437888736L
        };

        System.out.println("Decrypting Hashes:");
        for (Long hash : hashes) {
            Long pin = reverseHash(hash);
            System.out.println("Hash: " + hash + " => PIN: " + pin);
        }
    }
}

```


![[Pasted image 20250111140903.png]]

