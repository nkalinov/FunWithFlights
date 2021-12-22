import express, { Request, Response } from 'express';
import fetch from 'node-fetch';
import { DynamoDBClient, ListTablesCommand } from '@aws-sdk/client-dynamodb';
import { Route } from '../../models/Route';

const router = express.Router();

router.get('/', async (req: Request, res: Response) => {
  // just some mock data for the demo
  res.json([
    {
      airline: '2B',
      sourceAirport: 'AER',
      destinationAirport: 'KZN',
      codeShare: '',
      stops: 0,
      equipment: 'CR2',
    },
    {
      airline: '2B',
      sourceAirport: 'ASF',
      destinationAirport: 'KZN',
      codeShare: '',
      stops: 0,
      equipment: 'CR2',
    },
    {
      airline: '2B',
      sourceAirport: 'ASF',
      destinationAirport: 'MRV',
      codeShare: '',
      stops: 0,
      equipment: 'CR2',
    },
    {
      airline: '2B',
      sourceAirport: 'CEK',
      destinationAirport: 'KZN',
      codeShare: '',
      stops: 0,
      equipment: 'CR2',
    },
  ]);
});

router.get('/dynamo', async (req: Request, res: Response) => {
  const client = new DynamoDBClient({ region: 'eu-central-1' });

  try {
    const results = await client.send(new ListTablesCommand({}));
    res.send(results.TableNames?.join('\n'));
  } catch (err) {
    res.status(500).send(err);
  }
});

router.get('/flights1', async (req: Request, res: Response) => {
  try {
    const data = (await fetch(
      'http://ase.asmt.live:8000/provider/flights1'
    ).then(res => res.json())) as [Route];

    res.json(data);
  } catch (e) {
    res.status(500).send(e);
  }
});

export default router;
