import { useState } from 'react';
import {
  Button,
  Icon,
  Input,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';

import {
  CharacterPrefsTab,
  ContentPreferencesTab,
  GenitalTab,
  InteractionsTab,
  LewdItemsTab,
} from './tabs';

export const MainContent = () => {
  const [searchText, setSearchText] = useState('');
  const [tabIndex, setTabIndex] = useState(0);
  const [inFavorites, setInFavorites] = useState(false);
  const [showCategories, setShowCategories] = useState(false);

  return (
    <Section fill>
      <Stack vertical fill>
        <Stack.Item>
          <Tabs fluid textAlign="center">
            <Tabs.Tab
              selected={tabIndex === 0}
              onClick={() => setTabIndex(0)}
              rightSlot={
                <Button
                  icon={inFavorites ? 'star' : 'star-o'}
                  color="transparent"
                  onClick={() => setInFavorites(!inFavorites)}
                  tooltip={`Нажмите здесь, чтобы ${inFavorites ? 'показать все' : 'показать избранное'}`}
                />
              }
            >
              Взаимодействие
            </Tabs.Tab>
            <Tabs.Tab selected={tabIndex === 1} onClick={() => setTabIndex(1)}>
              Настройка гениталий
            </Tabs.Tab>
            <Tabs.Tab selected={tabIndex === 2} onClick={() => setTabIndex(2)}>
              Предпочтения персонажа
            </Tabs.Tab>
            <Tabs.Tab selected={tabIndex === 3} onClick={() => setTabIndex(3)}>
              Расширенные предпочтения
            </Tabs.Tab>
            <Tabs.Tab selected={tabIndex === 4} onClick={() => setTabIndex(4)}>
              Развратные предметы
            </Tabs.Tab>
          </Tabs>
        </Stack.Item>
        <Stack.Item>
          <Stack align="baseline" fill>
            <Stack.Item>
              <Icon name="search" />
            </Stack.Item>
            <Stack.Item grow>
              <Input
                fluid
                placeholder={
                  tabIndex === 0
                    ? 'Поиск взаимодействия'
                    : tabIndex === 1
                      ? 'Поиск гениталий'
                      : tabIndex === 3
                        ? 'Поиск предпочтений по содержанию'
                        : tabIndex === 4
                          ? 'Поиск предмета'
                          : 'Поиск недоступен для этой вкладки'
                }
                onChange={(value) => setSearchText(value)}
              />
            </Stack.Item>
            {tabIndex === 0 && (
              <Stack.Item>
                <Button
                  icon={showCategories ? 'folder' : 'list'}
                  color="green"
                  tooltip={
                    showCategories ? 'Скрыть категории' : 'Показать категории'
                  }
                  onClick={() => setShowCategories(!showCategories)}
                />
              </Stack.Item>
            )}
          </Stack>
        </Stack.Item>
        <Stack.Item grow basis={0} mb={-2.3}>
          <Section scrollable fill>
            {(() => {
              switch (tabIndex) {
                case 1:
                  return <GenitalTab searchText={searchText} />;
                case 2:
                  return <CharacterPrefsTab />;
                case 3:
                  return <ContentPreferencesTab searchText={searchText} />;
                case 4:
                  return <LewdItemsTab searchText={searchText} />;
                default:
                  return (
                    <InteractionsTab
                      searchText={searchText}
                      inFavorites={inFavorites}
                      showCategories={showCategories}
                    />
                  );
              }
            })()}
          </Section>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
