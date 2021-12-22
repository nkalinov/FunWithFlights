import express, { Request, Response } from 'express';
import fetch from 'node-fetch';
import { DynamoDBClient, ListTablesCommand } from '@aws-sdk/client-dynamodb';
import { Route } from '../../models/Route';

const router = express.Router();

async function fetchProviderData(url: string) {
  try {
    const res = (await fetch(url).then(res => res.json())) as any;
    if (res.errorCode) {
      // error
      throw new Error(res);
    }
    return res;
  } catch (e) {
    // todo logging
    return [];
  }
}

router.get('/', async (req: Request, res: Response) => {
  try {
    const dataProviders = await Promise.all([
      fetchProviderData('http://ase.asmt.live:8000/provider/flights1'),
      fetchProviderData('http://ase.asmt.live:8000/provider/flights2'),
      fetchProviderData('http://ase.asmt.live:8000/provider/flights3'),
    ]);

    // todo leave only the cheapest per hashkey

    const data = dataProviders.flat();
    //   .reduce((acc: any, route: Route) => {
    //   const hash = `${route.airline}_${route.sourceAirport}__${route.destinationAirport}`;
    //   acc[
    //
    //     ] = route;
    //   return acc;
    // }, {});

    res.json(data);
  } catch (e) {
    res.status(500).send(e);
  }
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
