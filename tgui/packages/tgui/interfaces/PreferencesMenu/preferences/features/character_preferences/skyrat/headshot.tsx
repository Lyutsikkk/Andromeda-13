// THIS IS A SKYRAT UI FILE
import { type Feature, FeatureShortTextInput } from '../../base';

export const headshot: Feature<string> = {
  name: '(Арт) Аватар',
  description:
    'Требуется ссылка, заканчивающаяся на .png, .jpeg или .jpg, начинающаяся с \
    https://, и размещенная на Catbox, Imgbox, Gyazo, Lensdump или F-List. \
    Отображает изображение под предварительным просмотром персонажа в окне «Подробнее». \
    Изображение размером более 250x250 будет уменьшено до 250x250. \
    По возможности старайтесь использовать размер 250x250',
  component: FeatureShortTextInput,
};
