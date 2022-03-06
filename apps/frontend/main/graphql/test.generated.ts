import * as Types from '@zingain-workspace/codegen-sdk/base-types';

import { DocumentNode } from 'graphql';
import * as Urql from 'urql';
export type Omit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>;
export type GetUsersFrontendQueryVariables = Types.Exact<{ [key: string]: never; }>;


export type GetUsersFrontendQuery = { __typename?: 'query_root', users: Array<{ __typename?: 'users', id: any, display_name?: string | null, account?: { __typename?: 'auth_accounts', email?: any | null } | null }> };


export const GetUsersFrontendDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"getUsersFrontend"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"users"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"display_name"}},{"kind":"Field","name":{"kind":"Name","value":"account"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"email"}}]}}]}}]}}]} as unknown as DocumentNode;

export function useGetUsersFrontendQuery(options?: Omit<Urql.UseQueryArgs<GetUsersFrontendQueryVariables>, 'query'>) {
  return Urql.useQuery<GetUsersFrontendQuery>({ query: GetUsersFrontendDocument, ...options });
};