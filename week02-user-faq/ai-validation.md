# AI Tool Use Statement

## What you asked the AI to help with.

I used the AI as an assistive tool to develop content. I asked the AI to provide me with ideas on how to organize some of this material. I requested the AI's assistance in creating drafts for the FAQ entries and supporting notes. And finally I requested that the AI research the most recent Windows 11 documentation so that I could write these instructions without having to rely on memory.

## Which instructions you tested on the live Windows 11 system.

Each of the five paths provided in the FAQ was tested individually by accessing the relevant path on my Windows 11 Enterprise Evaluation VM, version 25H2, build 26200.9278. I confirmed all five paths by manually testing each one prior to recording them. Each of the five entries has a screenshot associated with it that provides evidence of validation.

## One AI suggestion you accepted, revised, or rejected.

When the AI generated incorrect information regarding the layout of a page, I identified and documented each error in validated-steps.md. For instance, the AI instructed users to go to a Mouse pointer style section and locate the slider in order to configure their mouse cursor. There is no heading titled Mouse pointer style, and there are no labels identifying the four style tiles located at the top of the page. Therefore, I chose to reject the AI-generated instruction and created new language referencing the tiles based upon their position within the layout. Additionally, although the About page clearly states that my VM is running Enterprise Evaluation, the AI incorrectly assumed that my VM was running Windows 11 Pro. This error affected the lusrmgr escalation note because it relates to which editions of Windows contain the snap-in; therefore, I made corrections throughout.

## One example where you changed the wording to make it clearer for a non-technical user.

The AI authored "Do not use custom scaling values on a managed machine, since non-standard percentages cause layout problems in older applications." Although this statement is correct, it fails to inform users why they should be concerned, and few people who are not involved in IT know what either "non-standard percentages" or "layout problems" refer to. In contrast, I explained to users what occurs when they select custom scaling: "Instead of using Custom scaling, choose a value from the Scale drop-down menu. Windows advises against selecting custom values because they may render text and apps unreadable, they affect all displays, and changes are not applied until you sign out from your session, which may hinder recovery if you have selected a value that is too large."