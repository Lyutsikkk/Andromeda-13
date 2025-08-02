import { useBackend } from 'tgui/backend';
import { Button, Table } from 'tgui-core/components';

import type { AirAlarmData } from '../types';
import { useAlarmModal } from '../useModal';

export function AirAlarmControlThresholds(props) {
  const { act, data } = useBackend<AirAlarmData>();
  const [activeModal, setActiveModal] = useAlarmModal();
  const { tlvSettings, thresholdTypeMap } = data;

  return (
    <Table>
      <Table.Row>
        <Table.Cell bold>Порог</Table.Cell>
        <Table.Cell bold color="bad">
          Пониженная
        </Table.Cell>
        <Table.Cell bold color="average">
          Ниже среднего
        </Table.Cell>
        <Table.Cell bold color="average">
          Выше среднего
        </Table.Cell>
        <Table.Cell bold color="bad">
          Повышеная
        </Table.Cell>
        <Table.Cell bold>Действия</Table.Cell>
      </Table.Row>
      {tlvSettings.map((tlv) => (
        <Table.Row key={tlv.name} className="candystripe">
          <Table.Cell>{tlv.name}</Table.Cell>
          <Table.Cell>
            <Button
              fluid
              onClick={() =>
                setActiveModal({
                  id: tlv.id,
                  name: tlv.name,
                  type: thresholdTypeMap.hazard_min,
                  typeVar: 'hazard_min',
                  typeName: 'Minimum Hazard',
                  unit: tlv.unit,
                  finish: () => setActiveModal(undefined),
                })
              }
            >
              {tlv.hazard_min === -1
                ? 'Отключено'
                : `${tlv.hazard_min} ${tlv.unit}`}
            </Button>
          </Table.Cell>
          <Table.Cell>
            <Button
              fluid
              onClick={() =>
                setActiveModal({
                  id: tlv.id,
                  name: tlv.name,
                  type: thresholdTypeMap.warning_min,
                  typeVar: 'warning_min',
                  typeName: 'Minimum Warning',
                  unit: tlv.unit,
                  finish: () => setActiveModal(undefined),
                })
              }
            >
              {tlv.warning_min === -1
                ? 'Отключено'
                : `${tlv.warning_min} ${tlv.unit}`}
            </Button>
          </Table.Cell>
          <Table.Cell>
            <Button
              fluid
              onClick={() =>
                setActiveModal({
                  id: tlv.id,
                  name: tlv.name,
                  type: thresholdTypeMap.warning_max,
                  typeVar: 'warning_max',
                  typeName: 'Maximum Warning',
                  unit: tlv.unit,
                  finish: () => setActiveModal(undefined),
                })
              }
            >
              {tlv.warning_max === -1
                ? 'Отключено'
                : `${tlv.warning_max} ${tlv.unit}`}
            </Button>
          </Table.Cell>
          <Table.Cell>
            <Button
              fluid
              onClick={() =>
                setActiveModal({
                  id: tlv.id,
                  name: tlv.name,
                  type: thresholdTypeMap.hazard_max,
                  typeVar: 'hazard_max',
                  typeName: 'Maximum Hazard',
                  unit: tlv.unit,
                  finish: () => setActiveModal(undefined),
                })
              }
            >
              {tlv.hazard_max === -1
                ? 'Отключено'
                : `${tlv.hazard_max} ${tlv.unit}`}
            </Button>
          </Table.Cell>
          <Table.Cell>
            <Button
              color="green"
              icon="sync"
              onClick={() =>
                act('reset_threshold', {
                  threshold: tlv.id,
                  threshold_type: thresholdTypeMap.all,
                })
              }
            />
            <Button
              color="red"
              icon="times"
              onClick={() =>
                act('set_threshold', {
                  threshold: tlv.id,
                  threshold_type: thresholdTypeMap.all,
                  value: -1,
                })
              }
            />
          </Table.Cell>
        </Table.Row>
      ))}
    </Table>
  );
}
