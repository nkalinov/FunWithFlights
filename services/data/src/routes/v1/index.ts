import express from 'express';
import routes from './routes';

const router = express.Router();

// public
router.use('/routes', routes);

export default router;
