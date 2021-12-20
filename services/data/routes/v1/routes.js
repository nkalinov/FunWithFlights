import express from 'express';
import fetch from 'node-fetch';

const router = express.Router();

router.get('/', async (req, res) => {
  const routes1 = await fetch(
    'http://ase.asmt.live:8000/provider/flights1'
  ).then(res => res.json());

  res.json(routes1);
});

export default router;
