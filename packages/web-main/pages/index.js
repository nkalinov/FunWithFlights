import Head from 'next/head';
import styles from '../styles/Home.module.scss';
import { useEffect, useState } from 'react';

export default function Home() {
  return (
    <div className={styles.container}>
      <Head>
        <title>FunWithFlights</title>
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main className={styles.main}>
        <h1 className={styles.title}>Welcome to FunWithFlights!</h1>
        <p className={styles.description}>Compare flight options:</p>
        <Routes />
      </main>

      <footer className={styles.footer}>
        <a href="https://epam.com" target="_blank" rel="noopener noreferrer">
          Powered by EPAM.
        </a>
      </footer>
    </div>
  );
}

function Routes() {
  const [fetchState, setFetchState] = useState({
    status: 'pending',
    error: null,
    data: null,
  });

  useEffect(() => {
    async function fetchRoutes() {
      try {
        setFetchState(s => ({
          ...s,
          status: 'fetching',
        }));
        const data = await fetch('/api/data/v1/routes').then(res => res.json());
        setFetchState({
          status: 'ok',
          data,
        });
      } catch (e) {
        setFetchState({
          status: 'error',
          error: e,
        });
        throw e;
      }
    }

    let intervalId;
    fetchRoutes().then(() => {
      intervalId = setInterval(fetchRoutes, 5000);
    });
    return () => clearInterval(intervalId);
  }, []);

  if (
    (fetchState.status === 'pending' || fetchState.status === 'fetching') &&
    !fetchState.data
  ) {
    return 'Loading...';
  }

  if (fetchState.status === 'error') {
    return `Error: ${fetchState.error.message}`;
  }

  return (
    <div className={styles.grid}>
      {fetchState.data.map(route => (
        <a
          key={`${route.airline}-${route.sourceAirport}-${route.destinationAirport}`}
          href="#"
          className={styles.card}
        >
          <h2>{route.airline}</h2>
          <p>
            Source: {route.sourceAirport} | Destination: {route.destinationAirport}
          </p>
        </a>
      ))}
    </div>
  );
}
