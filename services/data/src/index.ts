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

// ALB can't strip prefixes yet but it's okay given that our infra is stored in the repo
// Check aws_lb_listener_rule.lb_path_data_service
app.use('/api/data/v1', routesV1);

// ECS health check endpoint (without the prefix because it's a LB-wide config)
app.use('/health', (req: Request, res: Response) => {
  res.sendStatus(200);
});

const port = process.env.PORT || 3000;

app.listen(port, () => {
  debug('Listening on ' + port);
});

export default app;
