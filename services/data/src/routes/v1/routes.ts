import express, { Request, Response } from 'express';
// import fetch from 'node-fetch';
import { DynamoDBClient, ListTablesCommand } from '@aws-sdk/client-dynamodb';

const router = express.Router();

const client = new DynamoDBClient({ region: 'eu-central-1' });

router.get('/', async (req: Request, res: Response) => {
  // const routes1 = await fetch(
  //   'http://ase.asmt.live:8000/provider/flights1'
  // ).then(res => res.json());

  try {
    const results = await client.send(new ListTablesCommand({}));
    res.send(results.TableNames?.join('\n'));
  } catch (err) {
    res.status(500).send(err);
  }
});

export default router;
