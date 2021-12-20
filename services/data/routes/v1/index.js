import express from 'express';
import routes from './routes.js';

const router = express.Router();

// public
router.use('/routes', routes);

export default router;
