import { Button, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../../backend';
import { ReagentLookup } from '../common/ReagentLookup';
import { RecipeLookup } from '../common/RecipeLookup';
import { bookmarkedReactions } from '.';
import { ReagentsData } from './types';

export function Lookup() {
  const { act, data } = useBackend<ReagentsData>();
  const { beakerSync, reagent_mode_recipe, reagent_mode_reagent } = data;

  return (
    <Stack fill>
      <Stack.Item grow basis={0}>
        <Section
          title="Поиск рецептов"
          minWidth="353px"
          buttons={
            <>
              <Button
                icon="atom"
                color={beakerSync ? 'green' : 'red'}
                tooltip="При включении функции отображения реакции автоматически отображаются текущие реакции в соответствующем стакане."
                onClick={() => act('beaker_sync')}
              >
                Синхронизация с мензуркой
              </Button>
              <Button
                icon="search"
                color="purple"
                tooltip="Поиск рецепта по названию продукта"
                onClick={() => act('search_recipe')}
              >
                Поиск
              </Button>
              <Button
                icon="times"
                color="red"
                disabled={!reagent_mode_recipe}
                onClick={() =>
                  act('recipe_click', {
                    id: null,
                  })
                }
              />
            </>
          }
        >
          <RecipeLookup
            recipe={reagent_mode_recipe}
            bookmarkedReactions={bookmarkedReactions}
          />
        </Section>
      </Stack.Item>
      <Stack.Item grow basis={0}>
        <Section
          title="Поиск реагентов"
          minWidth="300px"
          buttons={
            <>
              <Button
                icon="search"
                tooltip="Поиск реагента по названию"
                tooltipPosition="left"
                onClick={() => act('search_reagents')}
              >
                Поиск
              </Button>
              <Button
                icon="times"
                color="red"
                disabled={!reagent_mode_reagent}
                onClick={() =>
                  act('reagent_click', {
                    id: null,
                  })
                }
              />
            </>
          }
        >
          <ReagentLookup reagent={reagent_mode_reagent} />
        </Section>
      </Stack.Item>
    </Stack>
  );
}
