import { Button, Dropdown, Flex, LabeledList } from 'tgui-core/components';

import { useBackend } from '../../../backend';

type CharacterPrefsInfo = {
  erp_pref: string;
  erp_pref_values: string[];
  noncon_pref: string;
  noncon_pref_values: string[];
  vore_pref: string;
  vore_pref_values: string[];
  extreme_pref: string;
  extreme_pref_values: string[];
  unholy_pref: string;
  unholy_pref_values: string[];
  extreme_harm: string;
  extreme_harm_values: string[];
};

const getPrefIcon = (value: string) => {
  if (value === 'Ask (L)OOC' || value === 'Проверьте OOC заметки') {
    return 'question';
  }
  if (value === 'No') {
    return 'times';
  }
  return 'check';
};

const getPrefColor = (value: string) => {
  if (value === 'Ask (L)OOC' || value === 'Проверьте OOC заметки') {
    return 'yellow';
  }
  if (value === 'No') {
    return 'red';
  }
  return 'green';
};

export const CharacterPrefsTab = () => {
  const { act, data } = useBackend<CharacterPrefsInfo>();
  const {
    erp_pref,
    erp_pref_values,
    noncon_pref,
    noncon_pref_values,
    vore_pref,
    vore_pref_values,
    unholy_pref,
    unholy_pref_values,
    extreme_pref,
    extreme_pref_values,
    extreme_harm,
    extreme_harm_values,
  } = data;

  const renderPrefDropdown = (
    label: string,
    pref_key: string,
    current_value: string,
    options: string[],
  ) => {
    return (
      <LabeledList.Item
        label={label}
        color={getPrefColor(current_value)}
        buttons={
          <Button
            icon={getPrefIcon(current_value)}
            color={getPrefColor(current_value)}
          />
        }
      >
        <Dropdown
          width="200px"
          selected={current_value}
          options={options}
          onSelected={(value) =>
            act('char_pref', {
              char_pref: pref_key,
              value: value,
            })
          }
        />
      </LabeledList.Item>
    );
  };

  return (
    <Flex direction="column">
      <LabeledList>
        {renderPrefDropdown(
          'Предпочтение ЕРП',
          'erp_pref',
          erp_pref,
          erp_pref_values,
        )}
        {renderPrefDropdown(
          'Изнасилование',
          'noncon_pref',
          noncon_pref,
          noncon_pref_values,
        )}
        {renderPrefDropdown(
          'Предпочтение Воре',
          'vore_pref',
          vore_pref,
          vore_pref_values,
        )}
        {renderPrefDropdown(
          'Грязное ЕРП',
          'unholy_pref',
          unholy_pref,
          unholy_pref_values,
        )}
        {renderPrefDropdown(
          'Экстримальное ЕРП',
          'extreme_pref',
          extreme_pref,
          extreme_pref_values,
        )}
        {extreme_pref !== 'No' &&
          renderPrefDropdown(
            'Смертельное ЕРП',
            'extreme_harm',
            extreme_harm,
            extreme_harm_values,
          )}
      </LabeledList>
    </Flex>
  );
};
