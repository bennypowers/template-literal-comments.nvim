const query = /* sql */`
  SELECT
    l.[Label] as label
    , l.[Description] description
  FROM [Surveys].[dbo].[Lookup] l
  WHERE
    l.[Type] = 'SubmissionTitle'
    AND l.[Active] = 1
`;

const gql = /* gql */`
  query Foobar(thing: $thing) {
    sturff($thing) {
      blup
    }
  }
`;

const html = /* html */`
  <p>hi!</p>
`;

const css = /* css */`
  thingy-ding::part(front) {
    blup: frugg;
  }
`
