import { useBackend } from 'tgui/backend';
import { Button, Stack } from 'tgui-core/components';

import { RandomizationButton } from '../../components/RandomizationButton';
import { type PreferencesMenuData, RandomSetting } from '../../types';
import { useRandomToggleState } from '../../useRandomToggleState';
import { CheckboxInput, type Feature, type FeatureToggle } from './base';

export const random_body: Feature<RandomSetting> = {
  name: '(ПЕРСОНАЖ) Зарандомить персонажа',
  component: (props) => {
    const [randomToggle, setRandomToggle] = useRandomToggleState();
    const { act } = useBackend();

    return (
      <Stack>
        <Stack.Item>
          <RandomizationButton
            setValue={(newValue) => props.handleSetValue(newValue)}
            value={props.value}
          />
        </Stack.Item>

        {randomToggle ? (
          <>
            <Stack.Item>
              <Button
                color="green"
                onClick={() => {
                  act('randomize_character');
                  setRandomToggle(false);
                }}
              >
                Рандом
              </Button>
            </Stack.Item>

            <Stack.Item>
              <Button color="red" onClick={() => setRandomToggle(false)}>
                Отмена
              </Button>
            </Stack.Item>
          </>
        ) : (
          <Stack.Item>
            <Button onClick={() => setRandomToggle(true)}>Randomize</Button>
          </Stack.Item>
        )}
      </Stack>
    );
  },
};

export const random_hardcore: FeatureToggle = {
  name: '(ПЕРСОНАЖ) Хард рандом',
  component: CheckboxInput,
};

export const random_name: Feature<RandomSetting> = {
  name: 'Рандомное имя',
  component: (props) => {
    return (
      <RandomizationButton
        setValue={(value) => props.handleSetValue(value)}
        value={props.value}
      />
    );
  },
};

export const random_species: Feature<RandomSetting> = {
  name: 'Рандомная вид(раса)',
  component: (props) => {
    const { act, data } = useBackend<PreferencesMenuData>();

    const species = data.character_preferences.randomization.species;

    return (
      <RandomizationButton
        setValue={(newValue) =>
          act('set_random_preference', {
            preference: 'species',
            value: newValue,
          })
        }
        value={species || RandomSetting.Disabled}
      />
    );
  },
};
