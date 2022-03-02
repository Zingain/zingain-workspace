import { AppProps } from 'next/app';
import Head from 'next/head';
import { NhostApolloProvider } from '@nhost/react-apollo';
import { NhostAuthProvider } from '@nhost/react-auth'
import 'tailwindcss/tailwind.css';

import { client } from '../helpers/nhost';

function CustomApp({ Component, pageProps }: AppProps) {
  return (
    <>
      <NhostAuthProvider nhost={client}>
        <NhostApolloProvider graphqlUrl={process.env.NEXT_PUBLIC_GRAPHQL_URL }>
          <Head>
            <title>Welcome to main!</title>
          </Head>
          <main className="app">
            <Component {...pageProps} />
          </main>
        </NhostApolloProvider>
      </NhostAuthProvider>
    </>
  );
}

export default CustomApp;
