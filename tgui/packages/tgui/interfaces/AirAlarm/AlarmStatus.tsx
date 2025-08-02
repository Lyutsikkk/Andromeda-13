import { LabeledList, Section } from 'tgui-core/components';

import { useBackend } from '../../backend';
import type { AirAlarmData } from './types';

const dangerMap = {
  0: {
    color: 'good',
    localStatusText: 'В штатном режиме',
  },
  1: {
    color: 'average',
    localStatusText: 'Осторожно',
  },
  2: {
    color: 'bad',
    localStatusText: 'Опасно',
  },
} as const;

const faultMap = {
  0: {
    color: 'good',
    areaFaultText: 'Нету',
  },
  1: {
    color: 'purple',
    areaFaultText: 'Ручное срабатывание',
  },
  2: {
    color: 'average',
    areaFaultText: 'Автоматическое срабатывание',
  },
} as const;

export function AirAlarmStatus(props) {
  const { data } = useBackend<AirAlarmData>();
  const { envData } = data;

  const localStatus = dangerMap[data.dangerLevel] || dangerMap[0];
  const areaFault = faultMap[data.faultStatus] || faultMap[0];

  return (
    <Section title="Состояние воздуха">
      <LabeledList>
        {envData.length <= 0 ? (
          <LabeledList.Item label="Предупреждение" color="bad">
            Не удается получить пробу воздуха для анализа.
          </LabeledList.Item>
        ) : (
          <>
            {envData.map((entry) => {
              const status = dangerMap[entry.danger] || dangerMap[0];
              return (
                <LabeledList.Item
                  key={entry.name}
                  label={entry.name}
                  color={status.color}
                >
                  {entry.value}
                </LabeledList.Item>
              );
            })}
            <LabeledList.Item
              label="Локальный статус"
              color={localStatus.color}
            >
              {localStatus.localStatusText}
            </LabeledList.Item>
            <LabeledList.Item
              label="Статус области"
              color={data.atmosAlarm || data.fireAlarm ? 'bad' : 'good'}
            >
              {(data.atmosAlarm && 'Атмосферная сигнализация') ||
                (data.fireAlarm && 'Пожарная сигнализация') ||
                'В штатном режиме'}
            </LabeledList.Item>
            <LabeledList.Item
              label="Состояние неисправности"
              color={areaFault.color}
            >
              {areaFault.areaFaultText}
            </LabeledList.Item>
            <LabeledList.Item
              label="Местоположение неисправности"
              color={data.faultLocation ? 'blue' : 'good'}
            >
              {data.faultLocation || 'Нету'}
            </LabeledList.Item>
          </>
        )}
        {!!data.emagged && (
          <LabeledList.Item label="Предупреждение" color="bad">
            Меры безопасности в автономном режиме. Устройство может вести себя
            ненормально.
          </LabeledList.Item>
        )}
      </LabeledList>
    </Section>
  );
}
