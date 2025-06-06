import { Button, Flex, LabeledList } from 'tgui-core/components';

import { useRemappedBackend } from './helpers';
import { useTechWebRoute } from './hooks';
import { TechwebRouter } from './Router';

export function TechwebContent(props) {
  const { act, data } = useRemappedBackend();
  const {
    d_disk,
    node_cache,
    points_last_tick,
    point_types_abbreviations = [],
    points,
    queue_nodes = [],
    sec_protocols,
    t_disk,
  } = data;
  const [techwebRoute, setTechwebRoute] = useTechWebRoute();

  return (
    <Flex direction="column" className="Techweb__Viewport" height="100%">
      <Flex.Item className="Techweb__HeaderSection">
        <Flex className="Techweb__HeaderContent">
          <Flex.Item>
            <LabeledList>
              <LabeledList.Item label="Безопасность">
                <span
                  className={`Techweb__SecProtocol ${
                    !!sec_protocols && 'engaged'
                  }`}
                >
                  {sec_protocols ? 'Включено' : 'Отключено'}
                </span>
              </LabeledList.Item>
              {Object.keys(points).map((k) => (
                <LabeledList.Item key={k} label={point_types_abbreviations[k]}>
                  <b>{points[k]}</b>
                  {!!points_last_tick[k] && ` (+${points_last_tick[k]}/сек)`}
                </LabeledList.Item>
              ))}
              <LabeledList.Item label="Очередь">
                {queue_nodes.length !== 0
                  ? Object.keys(queue_nodes).map((node_id) => (
                      <Button
                        key={node_id}
                        tooltip={`Добавлено: ${queue_nodes[node_id]}`}
                      >
                        {node_cache[node_id].name}
                      </Button>
                    ))
                  : 'Пусто'}
              </LabeledList.Item>
            </LabeledList>
          </Flex.Item>
          <Flex.Item grow />
          <Flex.Item>
            <Button fluid onClick={() => act('toggleLock')} icon="lock">
              Забл. Консоль
            </Button>
            {d_disk && (
              <Flex.Item>
                <Button
                  fluid
                  onClick={() =>
                    setTechwebRoute({ route: 'disk', diskType: 'design' })
                  }
                >
                  Вставлен Диск с Проектом
                </Button>
              </Flex.Item>
            )}
            {t_disk && (
              <Flex.Item>
                <Button
                  fluid
                  onClick={() =>
                    setTechwebRoute({ route: 'disk', diskType: 'tech' })
                  }
                >
                  Вставлен Технический Диск
                </Button>
              </Flex.Item>
            )}
          </Flex.Item>
        </Flex>
      </Flex.Item>
      <Flex.Item className="Techweb__RouterContent" height="100%">
        <TechwebRouter />
      </Flex.Item>
    </Flex>
  );
}
