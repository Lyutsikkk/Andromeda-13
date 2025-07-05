import { useState } from 'react';
import { useDispatch, useSelector } from 'tgui/backend';
import {
  Button,
  Collapsible,
  Divider,
  Input,
  LabeledList,
  Section,
  Slider,
  Stack,
} from 'tgui-core/components';
import { toFixed } from 'tgui-core/math';
import { capitalize } from 'tgui-core/string';

import { clearChat, saveChatToDisk } from '../chat/actions';
import { THEMES } from '../themes';
import { exportSettings, updateSettings } from './actions';
import { FONTS } from './constants';
import { resetPaneSplitters, setEditPaneSplitters } from './scaling';
import { selectSettings } from './selectors';
import { importChatSettings } from './settingsImExport';

export function SettingsGeneral(props) {
  const { theme, fontFamily, fontSize, lineHeight } =
    useSelector(selectSettings);
  const dispatch = useDispatch();
  const [freeFont, setFreeFont] = useState(false);

  const [editingPanes, setEditingPanes] = useState(false);

  return (
    <Section>
      <LabeledList>
        <LabeledList.Item label="Тема">
          {THEMES.map((THEME) => (
            <Button
              key={THEME}
              selected={theme === THEME}
              color="transparent"
              onClick={() =>
                dispatch(
                  updateSettings({
                    theme: THEME,
                  }),
                )
              }
            >
              {capitalize(THEME)}
            </Button>
          ))}
        </LabeledList.Item>
        <LabeledList.Item label="Кастомный UI">
          <Stack>
            <Stack.Item>
              <Button
                onClick={() =>
                  setEditingPanes((val) => {
                    setEditPaneSplitters(!val);
                    return !val;
                  })
                }
                color={editingPanes ? 'red' : undefined}
                icon={editingPanes ? 'save' : undefined}
              >
                {editingPanes ? 'Сохранить' : 'Настройка UI'}
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button onClick={resetPaneSplitters} icon="refresh" color="red">
                Reset
              </Button>
            </Stack.Item>
          </Stack>
        </LabeledList.Item>
        <LabeledList.Item label="Стиль шрифта">
          <Stack.Item>
            {!freeFont ? (
              <Collapsible
                title={fontFamily}
                width={'100%'}
                buttons={
                  <Button
                    icon={freeFont ? 'lock-open' : 'lock'}
                    color={freeFont ? 'good' : 'bad'}
                    onClick={() => {
                      setFreeFont(!freeFont);
                    }}
                  >
                    Кастом шрифт
                  </Button>
                }
              >
                {FONTS.map((FONT) => (
                  <Button
                    key={FONT}
                    fontFamily={FONT}
                    selected={fontFamily === FONT}
                    color="transparent"
                    onClick={() =>
                      dispatch(
                        updateSettings({
                          fontFamily: FONT,
                        }),
                      )
                    }
                  >
                    {FONT}
                  </Button>
                ))}
              </Collapsible>
            ) : (
              <Stack>
                <Input
                  fluid
                  value={fontFamily}
                  onBlur={(value) =>
                    dispatch(
                      updateSettings({
                        fontFamily: value,
                      }),
                    )
                  }
                />
                <Button
                  ml={0.5}
                  icon={freeFont ? 'lock-open' : 'lock'}
                  color={freeFont ? 'good' : 'bad'}
                  onClick={() => {
                    setFreeFont(!freeFont);
                  }}
                >
                  Кастом шрифт
                </Button>
              </Stack>
            )}
          </Stack.Item>
        </LabeledList.Item>
        <LabeledList.Item label="Размер шрифта" verticalAlign="middle">
          <Stack textAlign="center">
            <Stack.Item grow>
              <Slider
                width="100%"
                step={1}
                stepPixelSize={20}
                minValue={8}
                maxValue={32}
                value={fontSize}
                unit="px"
                format={(value) => toFixed(value)}
                onChange={(e, value) =>
                  dispatch(updateSettings({ fontSize: value }))
                }
              />
            </Stack.Item>
          </Stack>
        </LabeledList.Item>
        <LabeledList.Item label="Высота линии">
          <Slider
            width="100%"
            step={0.01}
            minValue={0.8}
            maxValue={5}
            value={lineHeight}
            format={(value) => toFixed(value, 2)}
            onChange={(e, value) =>
              dispatch(
                updateSettings({
                  lineHeight: value,
                }),
              )
            }
          />
        </LabeledList.Item>
      </LabeledList>
      <Divider />
      <Stack fill>
        <Stack.Item mt={0.15}>
          <Button
            icon="compact-disc"
            tooltip="Экспорт настроек чата"
            onClick={() => dispatch(exportSettings())}
          >
            Экспорта настроек
          </Button>
        </Stack.Item>
        <Stack.Item mt={0.15}>
          <Button.File
            accept=".json"
            tooltip="Импорт настроек чата"
            icon="arrow-up-from-bracket"
            onSelectFiles={(files) => importChatSettings(files)}
          >
            Импорт настроек
          </Button.File>
        </Stack.Item>
        <Stack.Item grow mt={0.15}>
          <Button
            icon="save"
            tooltip="Экспорт истории текущих вкладок в HTML-файл"
            onClick={() => dispatch(saveChatToDisk())}
          >
            Сохранить логи чата
          </Button>
        </Stack.Item>
        <Stack.Item mt={0.15}>
          <Button.Confirm
            icon="trash"
            tooltip="Стереть историю текущих вкладок"
            onClick={() => dispatch(clearChat())}
          >
            Очистить чат
          </Button.Confirm>
        </Stack.Item>
      </Stack>
    </Section>
  );
}
