
-  Gotenberg is a API for converting  office documents and HTML/Markdown to PDF


## Kalmar CTF

 https://mariosk1574.com/posts/kalmar-ctf-2025-g0tchaberg


#### Set Up

- The flagbot service continuously sends requests to the gotenberg service to convert an HTML file (index.html) to a PDF every 5 seconds.

#### Gotenberg Operation:

- When a request is sent to the Gotenberg service, it creates a temporary directory with a random UUID in the `/tmp` directory.

- The HTML file to be converted is stored in this directory.

- Gotenberg processes the request, converts the HTML to a PDF, and then deletes the temporary directory.

#### Using waitDelay:

- The `waitDelay` option allows you to delay the conversion process. This is useful for observing the temporary files created by Gotenberg.

- By setting a `waitDelay`, you can inspect the `/tmp` directory before the files are deleted.




