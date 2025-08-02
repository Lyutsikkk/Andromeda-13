import { Button, Stack } from 'tgui-core/components';

import { useBackend } from '../../../../../../backend';
import {
  CheckboxInput,
  type Feature,
  type FeatureChoiced,
  FeatureNumberInput,
  type FeatureNumeric,
  FeatureSliderInput,
  type FeatureToggle,
} from '../../base';
import { FeatureDropdownInput } from '../../dropdowns';

const FeatureBlooperDropdownInput = (props) => {
  const { act } = useBackend();
  return (
    <Stack>
      <Stack.Item grow>
        <FeatureDropdownInput {...props} />
      </Stack.Item>
      <Stack.Item>
        <Button
          onClick={() => {
            act('play_blooper');
          }}
          icon="play"
          width="100%"
          height="100%"
        />
      </Stack.Item>
    </Stack>
  );
};

export const blooper_pitch_range: FeatureNumeric = {
  name: '(Голос) Диапазон голоса персонажа',
  description:
    '[0,1 - 0,8] Меньшее число - меньший диапазон. Большее число - больший диапазон.',
  component: FeatureNumberInput,
};

export const blooper_speech: FeatureChoiced = {
  name: '(Голос) Голос персонажа',
  component: FeatureBlooperDropdownInput,
};

export const blooper_speech_speed: FeatureNumeric = {
  name: '(Голос) Скорость голоса персонажа',
  description:
    '[2 - 16] Меньшее число - более быстрая скорость. Большее число - более медленный голос.',
  component: FeatureNumberInput,
};

export const blooper_speech_pitch: FeatureNumeric = {
  name: '(Голос) Высота голоса персонажа',
  description:
    '[0,4 - 2] Меньшее число - более глубокий тон. Большее число - более высокий шаг.',
  component: FeatureNumberInput,
};

export const hear_sound_blooper: FeatureToggle = {
  name: '(Голос) Включить прослушивания барков (голосов)',
  category: 'ЗВУК',
  component: CheckboxInput,
};

export const sound_blooper_volume: Feature<number> = {
  name: '(Голос) Громкость барков (голосов)',
  category: 'ЗВУК',
  description: 'Громкость, с которой будут воспроизводиться барки.',
  component: FeatureSliderInput,
};

export const send_sound_blooper: FeatureToggle = {
  name: '(Голос) Включить отправку голосовых сообщений',
  category: 'ЗВУК',
  component: CheckboxInput,
};
