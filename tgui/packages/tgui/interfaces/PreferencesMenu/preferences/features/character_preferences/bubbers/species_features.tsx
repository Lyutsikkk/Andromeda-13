import {
  CheckboxInput,
  type Feature,
  type FeatureChoiced,
  FeatureShortTextInput,
  FeatureTextInput,
  type FeatureToggle,
} from '../../base';
import { FeatureDropdownInput } from '../../dropdowns';

export const emote_length: FeatureChoiced = {
  name: 'Предпочтительная длина эмоции',
  category: 'ПОДРОБНЕЕ',
  description:
    'Какую продолжительность эмоций вы предпочитаете во время RP-сцены, если она у вас есть. Указывается в объявлении вашего персонажа.',
  component: FeatureDropdownInput,
};

export const approach_pref: FeatureChoiced = {
  name: 'Предпочтительный метод подхода',
  category: 'ПОДРОБНЕЕ',
  description:
    'Как бы вы хотели, чтобы к вам обращались для участия в RP-сценах, если это вообще возможно. Указано в объявлении о вашем персонаже.',
  component: FeatureDropdownInput,
};

export const furry_pref: FeatureChoiced = {
  name: 'Влечение: Фурри?',
  category: 'ПОДРОБНЕЕ',
  description:
    'Как и хотели бы вы участвовать в RP с пушистыми персонажами, такими как антропоморфы, птицелюди или инсектоиды.',
  component: FeatureDropdownInput,
};

export const scalie_pref: FeatureChoiced = {
  name: 'Влечение: Чешуйки?',
  category: 'ПОДРОБНЕЕ',
  description:
    'Как и хотели бы вы участвовать в RP со скалийскими персонажами, такими как ящерицы, рыбы или Драконы.',
  component: FeatureDropdownInput,
};

export const other_pref: FeatureChoiced = {
  name: 'Влечение: Другие?',
  category: 'ПОДРОБНЕЕ',
  description:
    'Как и хотели бы вы участвовать в RP с диковинными персонажами, такими как силиконы, тавры, Мегафауна и ксеносы.',
  component: FeatureDropdownInput,
};

export const demihuman_pref: FeatureChoiced = {
  name: 'Влечение: Полулюди?',
  category: 'ПОДРОБНЕЕ',
  description:
    'Как и хотели бы вы участвовать в RP с персонажами-получеловеками, такими как люди-кошки или собаки, монстры или демоны.',
  component: FeatureDropdownInput,
};

export const human_pref: FeatureChoiced = {
  name: 'Влечение: Человек?',
  category: 'ПОДРОБНЕЕ',
  description:
    'Как и хотели бы вы участвовать в RP с человеческими персонажами. Вы знаете, что такое человек.',
  component: FeatureDropdownInput,
};

export const character_ad: Feature<string> = {
  name: '(Заметки) Заметка к персонажу',
  description:
    'Встроенная заметка вашего персонажа. Расскажите о том, что вы ищете в плане ролевой игры и как найти подход к своему персонажу. Постарайтесь сделать больше, чем просто написать, что вы можете говорить в любое время.',
  component: FeatureTextInput,
};

export const attraction: FeatureChoiced = {
  name: '(ПЕРСОНАЖ) Привлекательность персонажа',
  description:
    'Классифицирует то, что привлекает вашего персонажа. Это отображается в каталоге.',
  component: FeatureDropdownInput,
};

export const display_gender: FeatureChoiced = {
  name: '(ПЕРСОНАЖ) Пол персонажа',
  description:
    'Какой пол соответствует вашему персонажу. Это отображается в каталоге.',
  component: FeatureDropdownInput,
};

export const flavor_text_nsfw: Feature<string> = {
  name: '(Описание) Описание внешность NSFW',
  description:
    'Фрагмент вашего текстового сообщения, который подвергается цензуре в программе examine. Используется для хранения визуальных сексуальных подробностей.',
  component: FeatureTextInput,
};

export const silicon_flavor_text_nsfw: Feature<string> = {
  name: '(Описание) Описание внешность NSFW (Синтетик)',
  description:
    'Фрагмент текста вашей внешности, сохраненный в examine, используется для силиконов. Используется для хранения визуальных сексуальных подробностей.',
  component: FeatureTextInput,
};

export const headshot_silicon: Feature<string> = {
  name: '(Арт) Аватар (Синтетик)',
  description:
    'Требуется ссылка, заканчивающаяся на .png, .jpeg или .jpg, начинающаяся с \
    https://, и размещенная на Catbox, Imgbox, Gyazo, Lensdump или F-List. \
    Отображает изображение под предварительным просмотром персонажа в окне «Подробнее». \
    Изображение размером более 250x250 будет уменьшено до 250x250. \
    По возможности старайтесь использовать размер 250x250',
  component: FeatureShortTextInput,
};

export const headshot_nsfw: Feature<string> = {
  name: '(Арт) Аватар NSFW',
  description:
    'Аватар, но для NSFW. \
    Требуется ссылка, заканчивающаяся на .png, .jpeg или .jpg, начинающаяся с  \
    https://, и размещенная на Catbox, Imgbox, Gyazo, Lensdump или F-List. \
    Отображает изображение под предварительным просмотром персонажа в окне «Подробнее». \
    Изображение размером более 250x250 будет уменьшено до 250x250. \
    По возможности старайтесь использовать размер 250x250',
  component: FeatureShortTextInput,
};

export const headshot_silicon_nsfw: Feature<string> = {
  name: '(Арт) Аватар (Синтетик) NSFW',
  description:
    // Headshot, but for NSFW references on Silicons. Не знаю как перевести.
    'Аватар, но для NSFW ссылка на Синтетика. \
    Требуется ссылка, заканчивающаяся на .png, .jpeg или .jpg, начинающаяся с  \
    https://, и размещенная на Catbox, Imgbox, Gyazo, Lensdump или F-List. \
    Отображает изображение под предварительным просмотром персонажа в окне «Подробнее». \
    Изображение размером более 250x250 будет уменьшено до 250x250. \
    По возможности старайтесь использовать размер 250x250',
  component: FeatureShortTextInput,
};

export const ooc_notes_silicon: Feature<string> = {
  name: '(Заметки) Заметки OOC (Синтетик)',
  description: 'То же самое, что и OOC-заметки, но для вашего синтетика!',
  component: FeatureTextInput,
};

export const custom_species_silicon: Feature<string> = {
  name: '(Лор) Название модели синтетика',
  description:
    'Название модуля для вашей компании синтетика, например, «Armadyne Pleasure Model»."',
  component: FeatureShortTextInput,
};

export const custom_species_lore_silicon: Feature<string> = {
  name: '(Лор) Лор синтетика',
  description:
    'Расскажите о своем синтетике: его фирме, марке, модели и деталях его создания.',
  component: FeatureTextInput,
};

export const art_ref: Feature<string> = {
  name: '(Арт) Ссылка на арт',
  description:
    'Ссылка на арт, которую другие могут увидеть для вашего персонажа \
    Требуется ссылка, заканчивающаяся на .png, .jpeg или .jpg, начинающаяся на \
    https://, и размещенная на Catbox, Imgbox, Gyazo, Lensdump или F-List.',
  component: FeatureShortTextInput,
};

export const art_ref_nsfw: FeatureToggle = {
  name: '(Арт) Ссылка на арт NSFW',
  description: 'Твоя картинка по ссылке - NSFW?',
  component: CheckboxInput,
};
