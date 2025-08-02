import { useState } from 'react';
import { Button, Modal } from 'tgui-core/components';

import { useBackend } from '../../backend';
import { TechwebContent } from './Content';
import { TechWebRoute } from './hooks';
import type { TechWebData } from './types';

export function TechwebStart(props) {
  const { act, data } = useBackend<TechWebData>();
  const { locked, stored_research } = data;
  const techwebState = useState({
    route: '',
  });

  if (locked) {
    return (
      <Modal width="15em" align="center" className="Techweb__LockedModal">
        <div>
          <b>Консоль Pаблокирована</b>
        </div>
        <Button icon="unlock" onClick={() => act('toggleLock')}>
          Разблокировать
        </Button>
      </Modal>
    );
  }

  if (!stored_research) {
    return (
      <Modal width="25em" align="center" className="Techweb__LockedModal">
        <div>
          <b>
            Не найдено ни одного исследования, пожалуйста, синхронизируйте
            консоль.
          </b>
        </div>
      </Modal>
    );
  }

  return (
    <TechWebRoute.Provider value={techwebState}>
      <TechwebContent />
    </TechWebRoute.Provider>
  );
}
