import { Fragment } from 'inferno';
import { useBackend } from "../backend";
import { Box, Button, Dropdown, LabeledList, ProgressBar, Section, Stack } from "../components";
import { Window } from "../layouts";
import { capitalize, toTitleCase } from 'common/string';

export const RIGSuit = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    interfacelock,
    malf,
    aicontrol,
    ai,
  } = data;

  let override = null;

  if (interfacelock || malf) {
    // Interface is offline, or a malf AI took over, either way, the user is
    // no longer permitted to view this interface.
    override = <Box color="bad">--HARDSUIT INTERFACE OFFLINE--</Box>;
  } else if (!ai && aicontrol) {
    // Non-AI trying to control the hardsuit while it's AI control overridden
    override = <Box color="bad">-- HARDSUIT CONTROL OVERRIDDEN BY AI --</Box>;
  }

  return (
    <Window
      height={480}
      width={550}
      resizable>
      <Window.Content scrollable>
        {override || (
          <Fragment>
            <RIGSuitStatus />
            <RIGSuitHardware />
            <RIGSuitModules />
          </Fragment>
        )}
      </Window.Content>
    </Window>
  );
};

const RIGSuitStatus = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    // Power Bar
    chargestatus,
    charge,
    maxcharge,
    // AI Control Toggle
    aioverride,
    // Suit Status
    sealing,
    sealed,
    // Cover Locks
    emagged,
    securitycheck,
    coverlock,
  } = data;

  const SealButton = (
    <Button
      content={"Suit " + (sealing
        ? "seals working..."
        : (sealed
          ? "is Active"
          : "is Inactive"))}
      icon={sealing ? "redo" : sealed ? "power-off" : "lock-open"}
      iconSpin={sealing}
      disabled={sealing}
      selected={sealed}
      onClick={() => act("toggle_seals")} />
  );

  const AIButton = (
    <Button
      content={"AI Control " + (aioverride ? "Enabled" : "Disabled")}
      selected={aioverride}
      icon="robot"
      onClick={() => act("toggle_ai_control")} />
  );

  return (
    <Section
      title="Status"
      buttons={(
        <Fragment>
          {SealButton}
          {AIButton}
        </Fragment>
      )}>
      <LabeledList>
        <LabeledList.Item label="Power Supply">
          <ProgressBar
            minValue={0}
            maxValue={50}
            value={chargestatus}
            ranges={{
              good: [35, Infinity],
              average: [15, 35],
              bad: [-Infinity, 15],
            }}>
            {charge} / {maxcharge}
          </ProgressBar>
        </LabeledList.Item>
        <LabeledList.Item label="Cover Status">
          {(emagged || !securitycheck) ? (
            <Box color="bad">Error - Maintenance Lock Control Offline</Box>
          ) : (
            <Button
              icon={coverlock ? "lock" : "lock-open"}
              content={coverlock ? "Locked" : "Unlocked"}
              onClick={() => act("toggle_suit_lock")} />
          )}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const RIGSuitHardware = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    // Disables buttons while the suit is busy
    sealing,
    // Each piece
    helmet,
    helmetDeployed,
    gauntlets,
    gauntletsDeployed,
    boots,
    bootsDeployed,
    chest,
    chestDeployed,
  } = data;

  return (
    <Section title="Hardware">
      <LabeledList>
        <LabeledList.Item
          label="Helmet"
          buttons={(
            <Button
              icon={helmetDeployed ? "sign-out-alt" : "sign-in-alt"}
              content={helmetDeployed ? "Deployed" : "Deploy"}
              disabled={sealing}
              selected={helmetDeployed}
              onClick={() => act("toggle_piece", { piece: 'helmet' })} />
          )}>
          {helmet ? capitalize(helmet) : "ERROR"}
        </LabeledList.Item>
        <LabeledList.Item
          label="Gauntlets"
          buttons={(
            <Button
              icon={gauntletsDeployed ? "sign-out-alt" : "sign-in-alt"}
              content={gauntletsDeployed ? "Deployed" : "Deploy"}
              disabled={sealing}
              selected={gauntletsDeployed}
              onClick={() => act("toggle_piece", { piece: 'gauntlets' })} />
          )}>
          {gauntlets ? capitalize(gauntlets) : "ERROR"}
        </LabeledList.Item>
        <LabeledList.Item
          label="Boots"
          buttons={(
            <Button
              icon={bootsDeployed ? "sign-out-alt" : "sign-in-alt"}
              content={bootsDeployed ? "Deployed" : "Deploy"}
              disabled={sealing}
              selected={bootsDeployed}
              onClick={() => act("toggle_piece", { piece: 'boots' })} />
          )}>
          {boots ? capitalize(boots) : "ERROR"}
        </LabeledList.Item>
        <LabeledList.Item
          label="Chestpiece"
          buttons={(
            <Button
              icon={chestDeployed ? "sign-out-alt" : "sign-in-alt"}
              content={chestDeployed ? "Deployed" : "Deploy"}
              disabled={sealing}
              selected={chestDeployed}
              onClick={() => act("toggle_piece", { piece: 'chest' })} />
          )}>
          {chest ? capitalize(chest) : "ERROR"}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const RIGSuitModules = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    // Seals disable Modules
    sealed,
    sealing,
    // Currently Selected system
    primarysystem,
    // The actual modules.
    modules,
    possible_tracking_levels,
    possible_tracking_modes,
  } = data;

  if (!sealed || sealing) {
    return (
      <Section title="Modules">
        <Box color="bad">
          HARDSUIT SYSTEMS OFFLINE
        </Box>
      </Section>
    );
  }

  return (
    <Section title="Modules">
      <Box mb="0.2rem" fontSize={1.5}>
        Selected Primary: {capitalize(primarysystem || "None")}
      </Box>
      {modules && modules.map((module, i) => (
        <Section
          key={module.name}
          level={2}
          title={toTitleCase(module.name) + (module.damage ? " (damaged)" : "")}
          buttons={(
            <Fragment>
              {module.can_select ? (
                <Button
                  selected={module.name === primarysystem}
                  content={module.name === primarysystem
                    ? "Selected"
                    : "Select"}
                  icon="arrow-circle-right"
                  onClick={() => act("interact_module", {
                    'module': module.index,
                    'module_mode': 'select',
                  })} />
              ) : null}
              {module.can_use ? (
                <Button
                  content={module.engagestring}
                  icon="arrow-circle-down"
                  onClick={() => act("interact_module", {
                    'module': module.index,
                    'module_mode': 'engage',
                  })} />
              ) : null}
              {module.can_toggle ? (
                <Button
                  selected={module.is_active}
                  content={module.is_active
                    ? module.deactivatestring
                    : module.activatestring}
                  icon="arrow-circle-down"
                  onClick={() => act("interact_module", {
                    'module': module.index,
                    'module_mode': 'toggle',
                  })} />
              ) : null}
            </Fragment>
          )}>
          {module.damage >= 2 ? (
            <Box color="bad">-- MODULE DESTROYED --</Box>
          ) : (
            <Stack>
              <Stack.Item grow nowrap>
                <Box color="average">Engage: {module.engagecost}</Box>
                <Box color="average">Active: {module.activecost}</Box>
                <Box color="average">Passive: {module.passivecost}</Box>
              </Stack.Item>
              <Stack.Item>
                {module.desc}
              </Stack.Item>
            </Stack>
          )}
          {module.healthbar_module ? (
            <Stack>
              <Stack.Item>
                <Dropdown
                  options={possible_tracking_modes}
                  selected={module.tracking_mode}
                  nochevron
                  noscroll
                  icon="map-marked-alt"
                  onSelected={(value) => act("change_tracking_mode", { "new_tracking_mode": value, "healthbar_ref": module.healthbar_module })} />
              </Stack.Item>
              <Stack.Item>
                <Dropdown
                  options={possible_tracking_levels}
                  selected={module.tracking_level}
                  nochevron
                  noscroll
                  width={15}
                  disabled={module.automatic_tracking}
                  icon="heart"
                  onSelected={(value) => act("change_tracking_level", { "tracking_level": value, "healthbar_ref": module.healthbar_module })} />
              </Stack.Item>
            </Stack>
          ) : null}
          {module.charges ? (
            <Section title="Module Charges">
              <LabeledList>
                <LabeledList.Item label="Selected">
                  {capitalize(module.chargetype)}
                </LabeledList.Item>
                {module.charges.map((charge, i) => (
                  <LabeledList.Item
                    key={charge.caption}
                    label={capitalize(charge.caption)}>
                    <Button
                      selected={module.realchargetype === charge.index}
                      icon="arrow-right"
                      onClick={() => act("interact_module", {
                        "module": module.index,
                        "module_mode": "select_charge_type",
                        "charge_type": charge.index,
                      })} />
                  </LabeledList.Item>
                ))}
              </LabeledList>
            </Section>
          ) : null}
        </Section>
      ))}
    </Section>
  );
};
