// THIS IS A SKYRAT SECTOR UI FILE
import { Feature, FeatureNumberInput } from '../../base';

export const chrono_age: Feature<number> = {
  name: '(ПЕРСОНАЖ) Возраст (хронологический)',
  description:
    'Хронологический возраст представляет собой то, сколько времени ваш персонаж фактически существует во вселенной с момента рождения.\
    Включает время, проведенное в криосне и/или в зонах гравитационного/скоростного замедления времени.',
  component: FeatureNumberInput,
};
