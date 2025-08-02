import { useState } from 'react';
import { Box, Button, Flex, Modal, Section } from 'tgui-core/components';
import { capitalize } from 'tgui-core/string';

import { useBackend } from '../../backend';
import { AlertButton } from './AlertButton';
import { MessageModal } from './MessageModal';
import { type CommsConsoleData, ShuttleState } from './types';

export function PageMain(props) {
  const { act, data } = useBackend<CommsConsoleData>();
  const {
    alertLevel,
    callShuttleReasonMinLength,
    canBuyShuttles,
    canMakeAnnouncement,
    canMessageAssociates,
    canRecallShuttles,
    canRequestNuke,
    canSendToSectors,
    canSetAlertLevel,
    canToggleEmergencyAccess,
    canToggleEngineeringOverride, // BUBBER EDIT - Engineering override
    emagged,
    syndicate,
    emergencyAccess,
    engineeringOverride, // BUBBER EDIT - Engineering override
    importantActionReady,
    sectors,
    shuttleCalled,
    shuttleCalledPreviously,
    shuttleCanEvacOrFailReason,
    shuttleLastCalled,
    shuttleRecallable,
  } = data;

  const [callingShuttle, setCallingShuttle] = useState(false);
  const [messagingAssociates, setMessagingAssociates] = useState(false);
  const [messagingSector, setMessagingSector] = useState('');
  const [requestingNukeCodes, setRequestingNukeCodes] = useState(false);

  const [newAlertLevel, setNewAlertLevel] = useState('');
  const showAlertLevelConfirm = newAlertLevel && newAlertLevel !== alertLevel;

  return (
    <Box>
      {!syndicate && (
        <Section title="Аварийный шаттл">
          {shuttleCalled ? (
            <Button.Confirm
              icon="space-shuttle"
              color="bad"
              disabled={!canRecallShuttles || !shuttleRecallable}
              tooltip={
                (canRecallShuttles &&
                  !shuttleRecallable &&
                  'Уже слишком поздно отзывать аварийный шаттл.') ||
                'У вас нет разрешения на вызов аварийного шаттла.'
              }
              tooltipPosition="top"
              onClick={() => act('recallShuttle')}
            >
              Отзыв аварийного шаттла
            </Button.Confirm>
          ) : (
            <Button
              icon="space-shuttle"
              disabled={shuttleCanEvacOrFailReason !== 1}
              tooltip={
                shuttleCanEvacOrFailReason !== 1
                  ? shuttleCanEvacOrFailReason
                  : undefined
              }
              tooltipPosition="top"
              onClick={() => setCallingShuttle(true)}
            >
              Вызовать аварийный шаттл
            </Button>
          )}
          {!!shuttleCalledPreviously &&
            (shuttleLastCalled ? (
              <Box>
                Последний сигнал шаттла/вызова: <b>{shuttleLastCalled}</b>
              </Box>
            ) : (
              <Box>Невозможно отследить последний сигнал шаттла/вызова.</Box>
            ))}
        </Section>
      )}

      {!!canSetAlertLevel && (
        <Section title="Уровень тревоги">
          <Flex justify="space-between">
            <Flex.Item>
              <Box>
                В настоящее время уровень кода <b>{capitalize(alertLevel)}</b>
              </Box>
            </Flex.Item>

            <Flex.Item>
              <AlertButton
                alertLevel="Зелёный"
                onClick={() => setNewAlertLevel('Зелёный')}
              />

              <AlertButton
                alertLevel="Синий"
                onClick={() => setNewAlertLevel('Синий')}
              />

              {/* BUBBER EDIT ADDITION BEGIN - ALERTS */}
              <AlertButton
                alertLevel="Фиолетовый"
                onClick={() => setNewAlertLevel('Фиолетовый')}
              />

              <AlertButton
                alertLevel="Оранжевый"
                onClick={() => setNewAlertLevel('Оранжевый')}
              />

              <AlertButton
                alertLevel="Янтарь"
                onClick={() => setNewAlertLevel('Янтарь')}
              />
              {/* BUBBER EDIT ADDITION END - ALERTS */}
            </Flex.Item>
          </Flex>
        </Section>
      )}

      <Section title="Функции">
        <Flex direction="column">
          {!!canMakeAnnouncement && (
            <Button
              icon="bullhorn"
              onClick={() => act('makePriorityAnnouncement')}
            >
              Сделать приоритетное объявление
            </Button>
          )}

          {!!canToggleEmergencyAccess && (
            <Button.Confirm
              icon="id-card-o"
              confirmIcon="id-card-o"
              color={emergencyAccess ? 'bad' : undefined}
              onClick={() => act('toggleEmergencyAccess')}
            >
              {emergencyAccess ? 'Включен' : 'Отключен'} доступ к аварийному
              обслуживанию
            </Button.Confirm>
          )}

          {/* BUBBER EDIT ADDITION START - Engineering Override */}
          {!!canToggleEngineeringOverride && (
            <Button.Confirm
              icon="wrench"
              color={engineeringOverride ? 'bad' : undefined}
              onClick={() => act('toggleEngOverride')}
            >
              {engineeringOverride ? 'Включен' : 'Отключен'} инженерный доступ
            </Button.Confirm>
          )}
          {/* BUBBER EDIT ADDITION END - Engineering Override */}

          {!syndicate && (
            <Button
              icon="desktop"
              onClick={() =>
                act('setState', { state: ShuttleState.CHANGING_STATUS })
              }
            >
              Настройка отображения дисплея
            </Button>
          )}

          <Button
            icon="envelope-o"
            onClick={() => act('setState', { state: ShuttleState.MESSAGES })}
          >
            Список сообщений
          </Button>

          {canBuyShuttles !== 0 && (
            <Button
              icon="shopping-cart"
              disabled={canBuyShuttles !== 1}
              // canBuyShuttles is a string detailing the fail reason
              // if one can be given
              tooltip={canBuyShuttles !== 1 ? canBuyShuttles : undefined}
              tooltipPosition="top"
              onClick={() =>
                act('setState', { state: ShuttleState.BUYING_SHUTTLE })
              }
            >
              Приобрести шаттл
            </Button>
          )}

          {!!canMessageAssociates && (
            <Button
              icon="comment-o"
              disabled={!importantActionReady}
              onClick={() => setMessagingAssociates(true)}
            >
              Отправить сообщение на {emagged ? '[НЕИЗВЕСТНО]' : 'ЦентКом'}
            </Button>
          )}

          {!!canRequestNuke && (
            <Button
              icon="radiation"
              disabled={!importantActionReady}
              onClick={() => setRequestingNukeCodes(true)}
            >
              Запрос кодов ядерной аутентификации
            </Button>
          )}

          {!!emagged && !syndicate && (
            <Button icon="undo" onClick={() => act('restoreBackupRoutingData')}>
              Восстановление резервных данных маршрутизации
            </Button>
          )}

          {/* BUBBER EDIT ADDITION BEGIN - Additional Calls */}
          {!!canMakeAnnouncement && (
            <Button icon="bullhorn" onClick={() => act('callThePolice')}>
              Позвоните в службу 911 правительства Террана: Антитеррор
            </Button>
          )}
          {!!canMakeAnnouncement && (
            <Button icon="bullhorn" onClick={() => act('callTheCatmos')}>
              Позвоните в службу 811 правительства Террана: Инженерное
              подразделение
            </Button>
          )}
          {!!canMakeAnnouncement && (
            <Button icon="bullhorn" onClick={() => act('callTheParameds')}>
              Позвоните в службу 711 правительства Террана: Медицинское
              подразделение
            </Button>
          )}
          {!!emagged && (
            <Button icon="bullhorn" onClick={() => act('callThePizza')}>
              Разместить заказ в Dogginos Pizza
            </Button>
          )}
          {/* BUBBER EDIT ADDITION END - Additional Calls */}
        </Flex>
      </Section>

      {!!canMessageAssociates && messagingAssociates && (
        <MessageModal
          label={`Message to transmit to ${
            emagged ? '[ABNORMAL ROUTING COORDINATES]' : 'CentCom'
          } via quantum entanglement`}
          notice="Please be aware that this process is very expensive, and abuse will lead to...termination. Transmission does not guarantee a response."
          icon="bullhorn"
          buttonText="Send"
          onBack={() => setMessagingAssociates(false)}
          onSubmit={(message) => {
            setMessagingAssociates(false);
            act('messageAssociates', {
              message,
            });
          }}
        />
      )}

      {!!canRequestNuke && requestingNukeCodes && (
        <MessageModal
          label="Reason for requesting nuclear self-destruct codes"
          notice="Misuse of the nuclear request system will not be tolerated under any circumstances. Transmission does not guarantee a response."
          icon="bomb"
          buttonText="Request Codes"
          onBack={() => setRequestingNukeCodes(false)}
          onSubmit={(reason) => {
            setRequestingNukeCodes(false);
            act('requestNukeCodes', {
              reason,
            });
          }}
        />
      )}

      {!!callingShuttle && (
        <MessageModal
          label="Nature of emergency"
          icon="space-shuttle"
          buttonText="Call Shuttle"
          minLength={callShuttleReasonMinLength}
          onBack={() => setCallingShuttle(false)}
          onSubmit={(reason) => {
            setCallingShuttle(false);
            act('callShuttle', {
              reason,
            });
          }}
        />
      )}

      {!!canSetAlertLevel && showAlertLevelConfirm && (
        <Modal>
          <Flex direction="column" textAlign="center" width="300px">
            <Flex.Item fontSize="16px" mb={2}>
              Swipe ID to confirm change
            </Flex.Item>

            <Flex.Item mr={2} mb={1}>
              <Button
                icon="id-card-o"
                color="good"
                fontSize="16px"
                onClick={() => {
                  act('changeSecurityLevel', {
                    newSecurityLevel: newAlertLevel,
                  });
                  setNewAlertLevel('');
                }}
              >
                Swipe ID
              </Button>

              <Button
                icon="times"
                color="bad"
                fontSize="16px"
                onClick={() => setNewAlertLevel('')}
              >
                Cancel
              </Button>
            </Flex.Item>
          </Flex>
        </Modal>
      )}

      {!!canSendToSectors && sectors.length > 0 && (
        <Section title="Allied Sectors">
          <Flex direction="column">
            {sectors.map((sectorName) => (
              <Flex.Item key={sectorName}>
                <Button
                  disabled={!importantActionReady}
                  onClick={() => setMessagingSector(sectorName)}
                >
                  Send a message to station in {sectorName} sector
                </Button>
              </Flex.Item>
            ))}

            {sectors.length > 2 && (
              <Flex.Item>
                <Button
                  disabled={!importantActionReady}
                  onClick={() => setMessagingSector('all')}
                >
                  Send a message to all allied station
                </Button>
              </Flex.Item>
            )}
          </Flex>
        </Section>
      )}

      {!!canSendToSectors && sectors.length > 0 && messagingSector && (
        <MessageModal
          label="Message to send to allied station"
          notice="Please be aware that this process is very expensive, and abuse will lead to...termination."
          icon="bullhorn"
          buttonText="Send"
          onBack={() => setMessagingSector('')}
          onSubmit={(message) => {
            act('sendToOtherSector', {
              destination: messagingSector,
              message,
            });

            setMessagingSector('');
          }}
        />
      )}
    </Box>
  );
}
