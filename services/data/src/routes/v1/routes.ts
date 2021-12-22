import express, { Request, Response } from 'express';
import fetch from 'node-fetch';
import { DynamoDBClient, ListTablesCommand } from '@aws-sdk/client-dynamodb';
import { Route } from '../../models/Route';

const router = express.Router();

router.get('/', async (req: Request, res: Response) => {
  try {
    const [data1, data2] = await Promise.all([
      fetch('http://ase.asmt.live:8000/provider/flights1').then(res =>
        res.json()
      ),
      fetch('http://ase.asmt.live:8000/provider/flights2').then(res =>
        res.json()
      ),
    ]);

    // todo group by hashkey
    // const data1ByHash = (data1 as [Route]).reduce((acc: any, route: Route) => {
    //   acc[
    //     `${route.airline}_${route.sourceAirport}__${route.destinationAirport}`
    //   ] = route;
    //   return acc;
    // }, {});
    // const data2ByHash = (data1 as [Route]).reduce((acc: any, route: Route) => {
    //   acc[
    //     `${route.airline}_${route.sourceAirport}__${route.destinationAirport}`
    //   ] = route;
    //   return acc;
    // }, {});

    // todo leave only the cheapest per hashkey

    const data = (data1 as [Route]).concat(data2 as [Route]);
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
