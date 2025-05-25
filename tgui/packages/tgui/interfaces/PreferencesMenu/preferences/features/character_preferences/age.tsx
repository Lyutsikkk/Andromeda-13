import { Feature, FeatureNumberInput } from '../base';

export const age: Feature<number> = {
  // name: 'Age', // ORIGINAL
  name: '(ПЕРСОНАЖ) Возраст (физический)', // SKYRAT EDIT CHANGE - Chronological age
  // SKYRAT EDIT ADDITION BEGIN - Chronological age
  description:
    'Физический возраст представляет, насколько ваш персонаж вырос физически и умственно.\
    Включает «нормальное» старение, например, опыт, который физически старит тело, и «антивозрастные» медицинские процедуры.\
    Не включает время, проведенное в крио-сне.',
  // SKYRAT EDIT ADDITION END
  component: FeatureNumberInput,
};
