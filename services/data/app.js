import express from 'express';
import cookieParser from 'cookie-parser';
import logger from 'morgan';
import createDebugger from 'debug';
import routesV1 from './routes/v1/index.js';

// todo fix
const debug = createDebugger('data:server');

const app = express();

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());

app.use('/api/data/v1', routesV1);
app.use('/api/data/health', (req, res) => {
  res.sendStatus(200);
});

const port = process.env.PORT || 3000;

app.listen(port, () => {
  debug('Listening on ' + port);
});

export default app;
