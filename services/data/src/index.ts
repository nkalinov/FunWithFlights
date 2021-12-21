import express, { Request, Response } from 'express';
import cookieParser from 'cookie-parser';
import logger from 'morgan';
import Debug from 'debug';
import routesV1 from './routes/v1';

const debug = Debug('data:server');
const app = express();

const isDev = process.env.NODE_ENV === 'development' || true;

app.use(logger(isDev ? 'dev' : 'tiny'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());

app.use('/api/data/v1', routesV1);
app.use('/api/data/health', (req: Request, res: Response) => {
  res.sendStatus(200);
});

const port = process.env.PORT || 3000;

app.listen(port, () => {
  debug('Listening on ' + port);
});

export default app;
