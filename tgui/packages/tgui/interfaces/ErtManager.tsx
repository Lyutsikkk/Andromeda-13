import { useState } from 'react';
import {
  Box,
  Button,
  Icon,
  LabeledList,
  Section,
  Stack,
  Tabs,
  TextArea,
} from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';
import { decodeHtmlEntities, toTitleCase } from 'tgui-core/string';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Data = {
  securityLevelColor: string;
  securityLevel: string;
  ertRequestAnswered: BooleanLike;
  ertType: string;
  adminSlots: number;
  commanderSlots: number;
  securitySlots: number;
  medicalSlots: number;
  engineeringSlots: number;
  inquisitorSlots: number;
  janitorSlots: number;
  totalSlots: number;
  ertSpawnpoints: number;
  ertRequestMessages: MessageType[];
  shouldBeAnnounced: BooleanLike;
};

type MessageType = {
  time: string;
  sender_real_name: string;
  sender_uid: string;
  message: string;
};

export const ErtManager = (props) => {
  const { act, data } = useBackend<Data>();
  const [tabIndex, setTabIndex] = useState(0);

  return (
    <Window width={360} height={505}>
      <Window.Content>
        <Stack fill vertical>
          <ERTOverview />
          <Stack.Item>
            <Tabs fluid>
              <Tabs.Tab
                key="SendERT"
                selected={tabIndex === 0}
                onClick={() => {
                  setTabIndex(0);
                }}
                icon="ambulance"
              >
                Отправить ОБР
              </Tabs.Tab>
              <Tabs.Tab
                key="ReadERTRequests"
                selected={tabIndex === 1}
                onClick={() => {
                  setTabIndex(1);
                }}
                icon="book"
              >
                Чтение запросов ОБР
              </Tabs.Tab>
              <Tabs.Tab
                key="DenyERT"
                selected={tabIndex === 2}
                onClick={() => {
                  setTabIndex(2);
                }}
                icon="times"
              >
                Отказать в ОБР
              </Tabs.Tab>
            </Tabs>
          </Stack.Item>
          {PickTab(tabIndex)}
        </Stack>
      </Window.Content>
    </Window>
  );
};

const PickTab = (index) => {
  switch (index) {
    case 0:
      return <SendERT />;
    case 1:
      return <ReadERTRequests />;
    case 2:
      return <DenyERT />;
    default:
      return "SOMETHING WENT VERY WRONG PLEASE AHELP, WAIT YOU'RE AN ADMIN, OH FUUUUCK! call a coder or something";
  }
};

const ERTOverview = (props) => {
  const { act, data } = useBackend<Data>();
  const { securityLevelColor, securityLevel, ertRequestAnswered } = data;

  return (
    <Stack.Item>
      <Section title="Настройка отряда">
        <LabeledList>
          <LabeledList.Item label="Текущий код">
            <Button icon="triangle-exclamation" color={securityLevelColor}>
              {securityLevel}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Запрос ОБР">
            <Button.Checkbox
              selected={null}
              checked={ertRequestAnswered}
              textColor={ertRequestAnswered ? null : 'bad'}
              tooltip={
                'Установка этого флажка отключит следующее уведомление с напоминанием о ОБР'
              }
              onClick={() => act('toggleErtRequestAnswered')}
            >
              {ertRequestAnswered ? 'Ответил' : 'Безответный'}
            </Button.Checkbox>
          </LabeledList.Item>
        </LabeledList>
      </Section>
    </Stack.Item>
  );
};

const SendERT = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    ertType,
    adminSlots,
    commanderSlots,
    totalSlots,
    ertSpawnpoints,
    shouldBeAnnounced,
  } = data;

  const ertNum = [0, 1, 2, 3, 4, 5];
  enum ERTJOB {
    security = 'setSec',
    medical = 'setMed',
    engineering = 'setEng',
    janitor = 'setJan',
    inquisitor = 'setInq',
  }

  enum ERTTYPE {
    Red = 'red',
    Gamma = 'orange',
    Epsilon = 'purple',
  }

  return (
    <Stack.Item grow>
      <Section
        fill
        title="Отправить ОБР"
        buttons={
          <>
            {Object.entries(ERTTYPE).map(([typeName, typeColor]) => (
              <Button
                key={ERTTYPE[typeName]}
                width={5}
                textAlign="center"
                color={ertType === typeName && typeColor}
                onClick={() => act('ertType', { ertType: typeName })}
              >
                {typeName}
              </Button>
            ))}
          </>
        }
      >
        <Stack fill vertical>
          <Stack.Item grow>
            <LabeledList>
              <LabeledList.Item label="Появиться на брифинге?">
                <Button
                  icon={adminSlots ? 'toggle-on' : 'toggle-off'}
                  selected={adminSlots}
                  tooltip="Нужно быть гостом"
                  onClick={() => act('toggleAdmin')}
                >
                  {adminSlots ? 'Да' : 'Нет'}
                </Button>
              </LabeledList.Item>
              <LabeledList.Item label="Должно ли быть объявлено об этом?">
                <Button
                  icon={shouldBeAnnounced ? 'toggle-on' : 'toggle-off'}
                  selected={shouldBeAnnounced}
                  tooltip="Последует ли оповещение после отказа/одобрения запроса?"
                  onClick={() => act('toggleAnnounce')}
                >
                  {shouldBeAnnounced ? 'Да' : 'Нет'}
                </Button>
              </LabeledList.Item>
              <LabeledList.Item label="Командир">
                <Button
                  icon={commanderSlots ? 'toggle-on' : 'toggle-off'}
                  selected={commanderSlots}
                  tooltip="Будет лидер при создании отряда или нет?"
                  onClick={() => act('toggleCom')}
                >
                  {commanderSlots ? 'Да' : 'Нет'}
                </Button>
              </LabeledList.Item>

              {Object.entries(ERTJOB).map(([typeName, typeAct]) => {
                const slotKey = `${typeName}Slots` as const;
                return (
                  <LabeledList.Item
                    key={ERTJOB[typeName]}
                    label={toTitleCase(typeName)}
                  >
                    {ertNum.map((number) => (
                      <Button
                        key={typeName + number}
                        selected={data[slotKey] === number}
                        onClick={() => act(typeAct, { [typeAct]: number })}
                      >
                        {number}
                      </Button>
                    ))}
                  </LabeledList.Item>
                );
              })}

              <LabeledList.Item label="Количество слотов">
                <Box color={totalSlots > ertSpawnpoints ? 'red' : 'green'}>
                  {totalSlots} исользованно из {ertSpawnpoints}
                </Box>
              </LabeledList.Item>
            </LabeledList>
          </Stack.Item>
          <Stack.Item>
            <Button
              fluid
              textAlign="center"
              icon="ambulance"
              onClick={() => act('dispatchErt')}
            >
              Отправить ОБР
            </Button>
          </Stack.Item>
        </Stack>
      </Section>
    </Stack.Item>
  );
};

const ReadERTRequests = (props) => {
  const { act, data } = useBackend<Data>();
  const { ertRequestMessages } = data;

  return (
    <Stack.Item grow>
      <Section fill>
        {ertRequestMessages && ertRequestMessages.length ? (
          ertRequestMessages.map((request) => (
            <Section
              key={decodeHtmlEntities(request.time)}
              title={request.time}
              buttons={
                <Button
                  onClick={() =>
                    act('view_player_panel', { uid: request.sender_uid })
                  }
                  tooltip="View player panel"
                >
                  {request.sender_real_name}
                </Button>
              }
            >
              {request.message}
            </Section>
          ))
        ) : (
          <Stack fill>
            <Stack.Item
              bold
              grow
              textAlign="center"
              align="center"
              color="average"
            >
              <Icon.Stack>
                <Icon name="broadcast-tower" size={5} color="gray" />
                <Icon name="slash" size={5} color="red" />
              </Icon.Stack>
              <br />
              Никаких запросов ОБР.
            </Stack.Item>
          </Stack>
        )}
      </Section>
    </Stack.Item>
  );
};

const DenyERT = (props) => {
  const { act, data } = useBackend();
  const [text, setText] = useState('');

  return (
    <Stack.Item grow>
      <Section fill>
        <Stack fill vertical>
          <Stack.Item grow>
            <TextArea
              height={'100%'}
              placeholder="Введите здесь причину отказа в ОБР. Допускается многострочный ввод."
              value={text}
              onChange={(e, value) => setText(value)}
            />
          </Stack.Item>
          <Stack.Item>
            <Button.Confirm
              fluid
              icon="times"
              textAlign="center"
              onClick={() => act('denyErt', { reason: text })}
            >
              Отказать в ОБР
            </Button.Confirm>
          </Stack.Item>
        </Stack>
      </Section>
    </Stack.Item>
  );
};
