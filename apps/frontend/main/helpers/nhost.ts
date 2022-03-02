import { NhostClient } from 'nhost-js-sdk';

const config = {
  baseURL: process.env.NEXT_PUBLIC_BACKEND_URL,
};

export const client: any = new NhostClient(config);
