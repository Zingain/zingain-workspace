import { getSdk } from '@zingain-workspace/codegen-sdk';
import { GraphQLClient } from 'graphql-request';

export const createHasura = () => {
  const config = {
    hasuraEndPoint: process.env.HASURA_GRAPHQL_ENDPOINT as string,
    hasuraAdminSecret: process.env.HASURA_GRAPHQL_ADMIN_SECRET as string,
  };
  console.log(config);

  const gqlEndPoint = `${config.hasuraEndPoint}/v1/graphql`;

  const client = new GraphQLClient(gqlEndPoint, {
    headers: { 'x-hasura-admin-secret': config.hasuraAdminSecret },
  });

  const sdk = getSdk(client);

  return {
    sdk: {
      ...sdk,
    },
  };
};

export type createHasuraReturn = ReturnType<typeof createHasura>;
